#!/usr/bin/env bash

#
# Script para realizar una auditoría de contribuciones en un repositorio de Git.
#
# Genera una tabla en formato Markdown con las siguientes métricas por autor:
# - Commits totales
# - Líneas añadidas/eliminadas (Total)
# - Archivos únicos modificados (Total)
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

# Redirige toda la salida estándar a un archivo markdown
# Los mensajes de error (stderr) seguirán saliendo por consola
exec > git_audit.md

echo "Iniciando auditoría automática del repositorio... (esto puede tardar en repositorios grandes)"
echo ""

# Preparar la cabecera de la tabla
header="| Autor | Commits | LA (Total) | LE (Total) | Archivos (Total) |"
separator="| :--- | :---: | :---: | :---: | :---: |"

if [[ -n "$SPECIFIC_EXTENSION" ]]; then
    header+=" LA (.$SPECIFIC_EXTENSION) | LE (.$SPECIFIC_EXTENSION) | Archivos (.$SPECIFIC_EXTENSION) |"
    separator+=" :---: | :---: | :---: |"
fi

echo "$header"
echo "$separator"

# Usar git shortlog para obtener la lista de autores y procesar cada uno
git shortlog -sne --all | while IFS= read -r shortlog_line; do
    # Extraer el número de commits y el string del autor (Nombre <email>)
    commit_count=$(echo "$shortlog_line" | awk '{print $1}')
    author_string=$(echo "$shortlog_line" | sed -e 's/^[ 	]*[0-9]	*[ 	]*//')

    # Usar el string exacto del autor para asegurar la precisión
    # --author="$author_string" hace una búsqueda de texto plano, no regex.
    
    # Métricas totales
    read -r total_la total_le < <(git log --all --author="$author_string" --numstat --pretty=tformat: | awk '{a+=$1; d+=$2} END {print a, d}')
    total_files=$(git log --all --author="$author_string" --name-only --pretty=tformat: | sort -u | wc -l)
    
    # Construir la fila de la tabla
    row="| $author_string | $commit_count | ${total_la:-0} | ${total_le:-0} | ${total_files:-0} |"

    # Métricas específicas de la extensión (si está configurada)
    if [[ -n "$SPECIFIC_EXTENSION" ]]; then
        read -r ext_la ext_le < <(git log --all --author="$author_string" --numstat --pretty=tformat: -- "**/*.$SPECIFIC_EXTENSION" | awk '{a+=$1; d+=$2} END {print a, d}')
        ext_files=$(git log --all --author="$author_string" --name-only --pretty=tformat: -- "**/*.$SPECIFIC_EXTENSION" | sort -u | wc -l)
        row+=" ${ext_la:-0} | ${ext_le:-0} | ${ext_files:-0} |"
    fi

    echo "$row"
done

echo ""
echo "Auditoría completada."