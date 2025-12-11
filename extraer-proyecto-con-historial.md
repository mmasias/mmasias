# Extraer un subdirectorio a un nuevo repositorio preservando el historial

## Contexto y objetivo

**Problema:** Tenemos un proyecto (por ejemplo, `pyProgresionesArmonicas`) dentro de un repositorio monolítico (`mmasias`), y queremos migrarlo a su propio repositorio independiente, **preservando todo el historial de commits** que documentan el proceso de creación.

**Valor:** El historial de commits documenta el proceso de desarrollo, las decisiones tomadas, la evolución del proyecto. Perder este historial significa perder contexto valioso.

## Por qué es importante (y difícil)

1. **git filter-branch** es la herramienta tradicional, pero está deprecated y tiene muchos "gotchas"
2. **git filter-repo** es la herramienta recomendada, pero no siempre está instalada
3. Los commits incluyen archivos de todo el repositorio, no solo del subdirectorio que queremos
4. Las rutas dentro del subdirectorio necesitan reorganizarse en el nuevo repo

## Solución implementada

### Enfoque elegido

Usamos **git archive** para extraer el contenido de cada commit histórico, y luego reconstruimos el repositorio commit por commit, preservando:
- Mensajes de commit
- Autor y email
- Fechas (author date y committer date)
- Orden cronológico

### Pasos del proceso

#### 1. Identificar los commits relevantes

```bash
cd /home/manuel/misRepos/mmasias

# Listar todos los commits que tocaron el proyecto cQuintas
git log --oneline --all -- "docs/music/cQuintas" "images/music/cQuintas"

# Generar lista completa en orden cronológico (del más antiguo al más reciente)
git log --reverse --pretty=format:"%H %s" -- \
  "docs/music/cQuintas" "images/music/cQuintas" \
  > /tmp/cquintas-commits.txt
```

**Resultado:** 18 commits identificados desde `feat: RUP.Requisitos` hasta `fix: ruta de imagenes`

#### 2. Crear script de extracción

El script procesa cada commit:

```bash
#!/bin/bash
set -e

ORIGINAL_REPO="/home/manuel/misRepos/mmasias"
NEW_REPO="/home/manuel/misRepos/pyProgresionesArmonicas"
COMMITS_FILE="/tmp/cquintas-commits.txt"

# Crear nuevo repositorio
mkdir -p "$NEW_REPO"
cd "$NEW_REPO"
git init
git config user.name "$(cd $ORIGINAL_REPO && git config user.name)"
git config user.email "$(cd $ORIGINAL_REPO && git config user.email)"

# Procesar cada commit
while IFS=' ' read -r hash message; do
    echo "Procesando commit $hash: $message"

    # Obtener info del commit original
    cd "$ORIGINAL_REPO"
    author=$(git log -1 --format='%an' $hash)
    author_email=$(git log -1 --format='%ae' $hash)
    author_date=$(git log -1 --format='%ai' $hash)
    commit_date=$(git log -1 --format='%ci' $hash)

    # Crear directorio temporal para este commit
    TEMP_DIR=$(mktemp -d)

    # Extraer archivos de cQuintas de este commit
    git archive $hash docs/music/cQuintas 2>/dev/null | tar -x -C "$TEMP_DIR" 2>/dev/null || true
    git archive $hash images/music/cQuintas 2>/dev/null | tar -x -C "$TEMP_DIR" 2>/dev/null || true

    # Reorganizar estructura: docs/music/cQuintas/* -> docs/*
    if [ -d "$TEMP_DIR/docs/music/cQuintas" ]; then
        mkdir -p "$TEMP_DIR/new_structure/docs"
        cp -r "$TEMP_DIR/docs/music/cQuintas"/* "$TEMP_DIR/new_structure/docs/" 2>/dev/null || true
    fi

    # Reorganizar estructura: images/music/cQuintas/* -> images/*
    if [ -d "$TEMP_DIR/images/music/cQuintas" ]; then
        mkdir -p "$TEMP_DIR/new_structure/images"
        cp -r "$TEMP_DIR/images/music/cQuintas"/* "$TEMP_DIR/new_structure/images/" 2>/dev/null || true
    fi

    # Copiar al nuevo repo
    cd "$NEW_REPO"
    if [ -d "$TEMP_DIR/new_structure" ]; then
        cp -r "$TEMP_DIR/new_structure"/* . 2>/dev/null || true

        # Hacer commit con la misma fecha y autor
        git add -A
        if ! git diff --cached --quiet 2>/dev/null; then
            GIT_AUTHOR_NAME="$author" \
            GIT_AUTHOR_EMAIL="$author_email" \
            GIT_AUTHOR_DATE="$author_date" \
            GIT_COMMITTER_NAME="$author" \
            GIT_COMMITTER_EMAIL="$author_email" \
            GIT_COMMITTER_DATE="$commit_date" \
            git commit -m "$message"
        fi
    fi

    # Limpiar
    rm -rf "$TEMP_DIR"

done < <(tail -n +1 "$COMMITS_FILE")

echo "Repositorio creado en: $NEW_REPO"
echo "Commits totales: $(git rev-list --count HEAD)"
```

#### 3. Ejecutar la extracción

```bash
chmod +x /tmp/extract-cquintas.sh
/tmp/extract-cquintas.sh
```

**Resultado:**
- Nuevo repositorio creado en `/home/manuel/misRepos/pyProgresionesArmonicas`
- 17 commits reconstruidos con historial completo

#### 4. Ajustar rutas de imágenes

Después de la extracción, las rutas en los archivos markdown apuntan a la estructura antigua:

```bash
cd /home/manuel/misRepos/pyProgresionesArmonicas

# Corregir rutas de 6 niveles (archivos en docs/music/cQuintas/RUP/00-requisitos/01-casos-de-uso/)
find . -name "*.md" -type f -exec sed -i 's|../../../../../images/music/cQuintas/RUP/|../../../../images/RUP/|g' {} \;

# Corregir rutas de 8 niveles (archivos en docs/music/cQuintas/RUP/00-requisitos/01-casos-de-uso/00-detalle/*)
find . -name "*.md" -type f -exec sed -i 's|../../../../../../../images/music/cQuintas/RUP/|../../../../../../images/RUP/|g' {} \;

# Commit de correcciones
git add -A
GIT_AUTHOR_NAME="manuel@sdf1" \
GIT_AUTHOR_EMAIL="manuel@masiasweb.com" \
GIT_AUTHOR_DATE="2025-12-11 00:34:12 +0100" \
GIT_COMMITTER_NAME="manuel@sdf1" \
GIT_COMMITTER_EMAIL="manuel@masiasweb.com" \
GIT_COMMITTER_DATE="2025-12-11 00:34:12 +0100" \
git commit -m "fix: ruta de imagenes"
```

#### 5. Reorganizar estructura final

Mover todo de `docs/` a la raíz del repositorio:

```bash
cd /home/manuel/misRepos/pyProgresionesArmonicas

# Mover archivos
mv docs/* .
rmdir docs

# Ajustar rutas de imágenes (reducir un nivel)
find . -name "*.md" -type f -exec sed -i 's|../../../../images/RUP/|../../../images/RUP/|g' {} \;
find . -name "*.md" -type f -exec sed -i 's|../../../../../../images/RUP/|../../../../../images/RUP/|g' {} \;

# Ajuste especial para archivos en 00-detalle (necesitan 6 niveles)
find RUP/00-requisitos/01-casos-de-uso/00-detalle -name "*.md" -type f -exec sed -i 's|../../../../images/RUP/|../../../../../images/RUP/|g' {} \;

# Commit final
git add -A
git commit -m "refactor: mover docs/ a raíz del repositorio"
```

## Estructura final

```
pyProgresionesArmonicas/
├── README.md              # Raíz del proyecto
├── cQuintas.html
├── cQuintas.js
├── ejemplos.md
├── RUP/                   # Documentación RUP directamente en raíz
│   ├── 00-requisitos/
│   ├── 01-analisis/
│   └── 02-diseno/
└── images/                # Imágenes separadas
    └── RUP/
```

## Verificación

```bash
cd /home/manuel/misRepos/pyProgresionesArmonicas

# Ver historial
git log --oneline

# Verificar estadísticas
echo "Total de commits: $(git rev-list --count HEAD)"
echo "Archivos markdown: $(find . -name '*.md' | wc -l)"
echo "Archivos PlantUML: $(find . -name '*.puml' | wc -l)"
echo "Archivos SVG: $(find . -name '*.svg' | wc -l)"

# Verificar rutas de imágenes
cd RUP/00-requisitos/01-casos-de-uso
ls -la ../../../images/RUP/00-requisitos/01-casos-de-uso/diagrama-contexto-musico.svg
```

## Ventajas de este enfoque

1. **No requiere git-filter-repo:** Solo usa herramientas estándar de Git
2. **Preserva metadatos:** Autor, email, fechas
3. **Flexible:** Permite reorganizar la estructura durante la extracción
4. **Reproducible:** El script puede adaptarse para otros proyectos
5. **Pedagógico:** Cada paso es comprensible y puede explicarse

## Desventajas y limitaciones

1. **No preserva merges:** Solo commits lineales
2. **Manual:** Requiere ajustar rutas después
3. **Lento:** Procesa commit por commit (pero para 18 commits es aceptable)
4. **Commits nuevos:** Los hashes de commit son diferentes (inevitable al reescribir historial)

## Alternativas consideradas

### git filter-branch (descartado)

```bash
git filter-branch --subdirectory-filter docs/music/cQuintas -- --all
```

**Problema:** Deprecated, complejo de usar correctamente, muchos edge cases.

### git filter-repo (no disponible)

```bash
git filter-repo --path docs/music/cQuintas --path images/music/cQuintas
```

**Problema:** Herramienta no instalada en el sistema.

### Subtree split (descartado)

```bash
git subtree split --prefix=docs/music/cQuintas -b cquintas-branch
```

**Problema:** No permite reorganizar la estructura fácilmente.

## Aplicación a otros proyectos

Para adaptar este proceso a otro proyecto:

1. Identificar las rutas del proyecto a extraer
2. Modificar las variables del script:
   ```bash
   ORIGINAL_REPO="/ruta/al/repo/original"
   NEW_REPO="/ruta/al/nuevo/repo"
   ```
3. Actualizar los patrones de búsqueda:
   ```bash
   git log --reverse --pretty=format:"%H %s" -- "ruta/al/proyecto" > commits.txt
   ```
4. Ajustar la reorganización de estructura según necesidades
5. Corregir rutas en archivos markdown/código

## Publicar en GitHub

Una vez listo el repositorio:

```bash
cd /home/manuel/misRepos/pyProgresionesArmonicas

# Crear repositorio en GitHub (vía web)
# Luego:
git remote add origin git@github.com:usuario/pyProgresionesArmonicas.git
git branch -M main
git push -u origin main
```

## Conclusión

Este enfoque manual pero controlado permite extraer un proyecto de un monorepo preservando:
- ✅ Todo el historial de commits
- ✅ Metadatos de autor y fechas
- ✅ Mensajes de commit originales
- ✅ Flexibilidad para reorganizar estructura

Es especialmente útil cuando se valora el **proceso de creación** documentado en el historial de Git, como en proyectos pedagógicos donde el énfasis está en el proceso de construcción.

---

**Fecha:** 2025-12-11
**Proyecto extraído:** pyProgresionesArmonicas
**Commits preservados:** 19 (17 originales + 2 de reorganización)
