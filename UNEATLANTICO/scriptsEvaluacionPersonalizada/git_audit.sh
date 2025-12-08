#!/usr/bin/env bash

#
# Script para realizar una auditoría de contribuciones en un repositorio de Git.
#
# Genera una tabla en formato Markdown con las siguientes métricas por autor:
# - Commits totales
# - Líneas añadidas/eliminadas (Total)
# - Archivos únicos modificados (Total)
# - Días activos (días diferentes con commits)
# - Porcentaje de contribución (basado en commits)
# - Métricas opcionales para una extensión de archivo específica.
#

# --- CONFIGURACIÓN ---

# Define la extensión de archivo específica que quieres analizar en detalle.
# No incluyas el punto. Déjalo en blanco ("" para omitir esta parte.
SPECIFIC_EXTENSION="puml"

# --- FIN DE LA CONFIGURACIÓN ---

# Salir si un comando falla o si una variable no está definida
set -euo pipefail

# Comprueba si estamos en un repositorio de Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1;
then
    echo "Error: Este script debe ejecutarse desde la raíz de un repositorio de Git." >&2
    exit 1
fi

# Sincronizar todas las ramas remotas para incluir el trabajo de todos los colaboradores
echo "Sincronizando ramas remotas..." >&2
if ! git fetch --all --quiet 2>&1; then
    echo "Advertencia: No se pudieron sincronizar algunas ramas remotas. Continuando con las ramas locales disponibles." >&2
fi

# Obtener información del repositorio
repo_name=$(basename "$(git rev-parse --show-toplevel)")
repo_url=$(git config --get remote.origin.url 2>/dev/null || echo "No remote URL configured")

# Si la URL es SSH, convertirla a HTTPS para el enlace
if [[ "$repo_url" =~ ^git@ ]]; then
    repo_url=$(echo "$repo_url" | sed -e 's/:/\//' -e 's/git@/https:\/\//' -e 's/\.git$//')
elif [[ "$repo_url" =~ \.git$ ]]; then
    repo_url="${repo_url%.git}"
fi

# Redirige toda la salida estándar a un archivo markdown
# Los mensajes de error (stderr) seguirán saliendo por consola
exec > git_audit.md

echo "# Auditoría numérica: $repo_name"
echo ""
echo "[$repo_url]($repo_url)"
echo ""

# Calcular totales del repositorio para porcentajes
total_commits=$(git log --all --oneline | wc -l)

# Preparar la cabecera de la tabla
header="| Autor | Commits | Días activos | % Contrib. | LA (Total) | LE (Total) | Archivos (Total) |"
separator="| :--- | :---: | :---: | :---: | :---: | :---: | :---: |"

if [[ -n "$SPECIFIC_EXTENSION" ]]; then
    header+=" LA (.$SPECIFIC_EXTENSION) | LE (.$SPECIFIC_EXTENSION) | Archivos (.$SPECIFIC_EXTENSION) |"
    separator+=" :---: | :---: | :---: |"
fi

# Agregar columna SOS al final
header+=" SOS |"
separator+=" :---: |"

echo "$header"
echo "$separator"

# Crear un archivo temporal para almacenar las filas antes de ordenarlas
temp_file=$(mktemp)

# Obtener lista única de emails (esto consolida autores con mismo email)
git log --all --pretty=format:"%aE" | sort -u | while IFS= read -r email; do
    # Para cada email, obtener el nombre más reciente usado
    author_name=$(git log --all --pretty=format:"%aE|%aN" | awk -F'|' -v e="$email" '$1 == e {print $2; exit}')
    author_string="$author_name <$email>"

    # Contar commits, líneas y archivos para este email exacto
    commit_count=$(git log --all --pretty=format:"%aE" | awk -v e="$email" '$0 == e {count++} END {print count+0}')

    # Métricas totales (filtrando por email exacto)
    read -r total_la total_le < <(git log --all --pretty=format:"%aE" --numstat | awk -v email="$email" '
        /@/ { current_email = $0; next }
        NF == 3 && $1 ~ /^[0-9]+$/ && $2 ~ /^[0-9]+$/ { if (current_email == email) { a+=$1; d+=$2 } }
        END { print a+0, d+0 }
    ')

    total_files=$(git log --all --pretty=format:"%aE" --name-only | awk -v email="$email" '
        /@/ { current_email = $0; next }
        NF == 1 && length($0) > 0 { if (current_email == email) files[$0]=1 }
        END { print length(files) }
    ')

    # Días activos (días únicos con commits para este email)
    active_days=$(git log --all --pretty=format:"%aE|%ad" --date=short | awk -F'|' -v e="$email" '$1 == e {days[$2]=1} END {print length(days)}')

    # Detectar commits con fechas manipuladas
    suspicious_commits=$(git log --all --pretty=format:"%aE|%at|%ct" | awk -F'|' -v e="$email" '$1 == e {diff = ($3 - $2); if (diff < 0) diff = -diff; if (diff > 86400) count++} END {print count+0}')

    # Porcentaje de contribución
    if [[ $total_commits -gt 0 ]]; then
        contribution_pct=$(LC_NUMERIC=C awk "BEGIN {printf \"%.1f\", ($commit_count / $total_commits) * 100}")
    else
        contribution_pct="0.0"
    fi

    # Reemplazar ceros por guiones para mejor legibilidad
    total_la_display="${total_la:-0}"; [[ "$total_la_display" == "0" ]] && total_la_display="-"
    total_le_display="${total_le:-0}"; [[ "$total_le_display" == "0" ]] && total_le_display="-"
    total_files_display="${total_files:-0}"; [[ "$total_files_display" == "0" ]] && total_files_display="-"
    suspicious_display="${suspicious_commits}"; [[ "$suspicious_display" == "0" ]] && suspicious_display="-"

    # Construir la fila de la tabla (sin SOS todavía)
    row="| $author_string | $commit_count | $active_days | ${contribution_pct}% | ${total_la_display} | ${total_le_display} | ${total_files_display} |"

    # Métricas específicas de la extensión (si está configurada)
    if [[ -n "$SPECIFIC_EXTENSION" ]]; then
        read -r ext_la ext_le < <(git log --all --pretty=format:"%aE" --numstat -- "**/*.$SPECIFIC_EXTENSION" | awk -v email="$email" '
            /@/ { current_email = $0; next }
            NF == 3 && $1 ~ /^[0-9]+$/ && $2 ~ /^[0-9]+$/ { if (current_email == email) { a+=$1; d+=$2 } }
            END { print a+0, d+0 }
        ')

        ext_files=$(git log --all --pretty=format:"%aE" --name-only -- "**/*.$SPECIFIC_EXTENSION" | awk -v email="$email" '
            /@/ { current_email = $0; next }
            NF == 1 && length($0) > 0 { if (current_email == email) files[$0]=1 }
            END { print length(files) }
        ')

        ext_la_display="${ext_la:-0}"; [[ "$ext_la_display" == "0" ]] && ext_la_display="-"
        ext_le_display="${ext_le:-0}"; [[ "$ext_le_display" == "0" ]] && ext_le_display="-"
        ext_files_display="${ext_files:-0}"; [[ "$ext_files_display" == "0" ]] && ext_files_display="-"

        row+=" ${ext_la_display} | ${ext_le_display} | ${ext_files_display} |"
    fi

    # Agregar columna SOS al final
    row+=" ${suspicious_display} |"

    # Guardar la fila con el porcentaje al inicio para ordenar
    echo "${contribution_pct}|${row}" >> "$temp_file"
done

# Ordenar las filas por porcentaje de contribución (de mayor a menor) y mostrarlas
sort -t'|' -k1 -nr "$temp_file" | cut -d'|' -f2-

# Limpiar archivo temporal
rm -f "$temp_file"

echo ""
echo "Auditoría completada."