# Extracción de subdirectorio a repositorio independiente preservando historial

## ¿Por qué?

Se presenta un escenario común en gestión de repositorios: un proyecto (`pyProgresionesArmonicas`) reside dentro de un repositorio monolítico (`mmasias`) y requiere migración a repositorio independiente. El valor crítico es el historial de commits, que documenta decisiones técnicas, evolución del diseño y proceso de construcción.

Las herramientas convencionales presentan limitaciones técnicas o prácticas:

- `git filter-branch`: deprecated desde Git 2.5, múltiples casos límite no documentados, tendencia a corromper historial en operaciones complejas
- `git filter-repo`: herramienta recomendada oficialmente pero no incluida en instalación estándar de Git, requiere instalación adicional mediante pip o compilación
- Commits en repositorio fuente incluyen archivos de múltiples proyectos no relacionados, requiere filtrado selectivo
- Estructura de rutas dentro del subdirectorio necesita reorganización: `docs/music/cQuintas` debe convertirse en raíz del nuevo repositorio

La pérdida de historial elimina contexto técnico valioso: razones de implementación, decisiones de diseño descartadas, evolución de requisitos.

## ¿Qué?

Reconstrucción de repositorio independiente que preserve la secuencia completa de cambios documentada en el historial original, junto con toda la información de autoría y temporalidad de cada modificación.

El enfoque debería permitir reorganización estructural simultánea: los archivos extraídos se reubicarían según la estructura objetivo del nuevo repositorio mientras se mantiene la trazabilidad de cada cambio a través del historial reconstruido.

## ¿Para qué?

- Preservación de historial completo.
- Independencia de herramientas no estándar.
- Reproducibilidad.
- Verificabilidad.

## ¿Cómo?

### Paso 1: Identificación de commits relevantes

```bash
cd /home/manuel/misRepos/mmasias

# Generar lista cronológica de commits que afectaron el proyecto
git log --reverse --pretty=format:"%H %s" -- \
  "docs/music/cQuintas" "images/music/cQuintas" \
  > /tmp/cquintas-commits.txt
```

Resultado: 18 commits desde `feat: RUP.Requisitos` hasta `fix: ruta de imagenes`.

### Paso 2: Script de extracción

```bash
#!/bin/bash
set -e

ORIGINAL_REPO="/home/manuel/misRepos/mmasias"
NEW_REPO="/home/manuel/misRepos/pyProgresionesArmonicas"
COMMITS_FILE="/tmp/cquintas-commits.txt"

# Inicializar repositorio destino
mkdir -p "$NEW_REPO"
cd "$NEW_REPO"
git init
git config user.name "$(cd $ORIGINAL_REPO && git config user.name)"
git config user.email "$(cd $ORIGINAL_REPO && git config user.email)"

# Procesar cada commit
while IFS=' ' read -r hash message; do
    echo "Procesando commit $hash: $message"

    # Extraer metadatos del commit original
    cd "$ORIGINAL_REPO"
    author=$(git log -1 --format='%an' $hash)
    author_email=$(git log -1 --format='%ae' $hash)
    author_date=$(git log -1 --format='%ai' $hash)
    commit_date=$(git log -1 --format='%ci' $hash)

    # Crear directorio temporal
    TEMP_DIR=$(mktemp -d)

    # Extraer archivos del proyecto en este commit específico
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

    # Copiar al repositorio destino y crear commit
    cd "$NEW_REPO"
    if [ -d "$TEMP_DIR/new_structure" ]; then
        cp -r "$TEMP_DIR/new_structure"/* . 2>/dev/null || true

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

    rm -rf "$TEMP_DIR"

done < <(tail -n +1 "$COMMITS_FILE")

echo "Repositorio creado en: $NEW_REPO"
echo "Commits totales: $(git rev-list --count HEAD)"
```

**Detalles técnicos críticos**:

- `git archive $hash path`: extrae contenido de `path` en el estado del commit `hash`, sin checkout completo
- Variables de entorno `GIT_AUTHOR_*` y `GIT_COMMITTER_*`: preservan timestamps y autoría originales
- `git diff --cached --quiet`: evita commits vacíos cuando un commit original no modificó archivos del proyecto
- `|| true`: permite continuar si un commit particular no contiene archivos del proyecto

### Paso 3: Ejecución

```bash
chmod +x /tmp/extract-cquintas.sh
/tmp/extract-cquintas.sh
```

Resultado: 17 commits reconstruidos en `/home/manuel/misRepos/pyProgresionesArmonicas`.

### Paso 4: Corrección de rutas de imágenes

```bash
cd /home/manuel/misRepos/pyProgresionesArmonicas

# Archivos en docs/music/cQuintas/RUP/00-requisitos/01-casos-de-uso/
# Referencias: ../../../../../images/music/cQuintas/RUP/
# Nueva ruta:  ../../../../images/RUP/
find . -name "*.md" -type f -exec sed -i \
  's|../../../../../images/music/cQuintas/RUP/|../../../../images/RUP/|g' {} \;

# Archivos en docs/music/cQuintas/RUP/00-requisitos/01-casos-de-uso/00-detalle/
# Referencias: ../../../../../../../images/music/cQuintas/RUP/
# Nueva ruta:  ../../../../../../images/RUP/
find . -name "*.md" -type f -exec sed -i \
  's|../../../../../../../images/music/cQuintas/RUP/|../../../../../../images/RUP/|g' {} \;

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

### Paso 5: Reorganización a estructura final

```bash
cd /home/manuel/misRepos/pyProgresionesArmonicas

# Mover contenido de docs/ a raíz
mv docs/* .
rmdir docs

# Ajustar rutas (reducir un nivel de anidación)
find . -name "*.md" -type f -exec sed -i \
  's|../../../../images/RUP/|../../../images/RUP/|g' {} \;
find . -name "*.md" -type f -exec sed -i \
  's|../../../../../../images/RUP/|../../../../../images/RUP/|g' {} \;

# Caso especial: archivos en 00-detalle/ necesitan 6 niveles
find RUP/00-requisitos/01-casos-de-uso/00-detalle -name "*.md" -type f -exec sed -i \
  's|../../../../images/RUP/|../../../../../images/RUP/|g' {} \;

# Commit final
git add -A
git commit -m "refactor: mover docs/ a raíz del repositorio"
```

**Estructura resultante**:

```
pyProgresionesArmonicas/
├── README.md
├── cQuintas.html
├── cQuintas.js
├── ejemplos.md
├── RUP/
│   ├── 00-requisitos/
│   ├── 01-analisis/
│   └── 02-diseno/
└── images/
    └── RUP/
```

### Verificación

```bash
cd /home/manuel/misRepos/pyProgresionesArmonicas

# Inspeccionar historial reconstruido
git log --oneline

# Estadísticas
echo "Commits: $(git rev-list --count HEAD)"
echo "Archivos .md: $(find . -name '*.md' | wc -l)"
echo "Archivos .puml: $(find . -name '*.puml' | wc -l)"
echo "Archivos .svg: $(find . -name '*.svg' | wc -l)"

# Verificar una ruta específica
cd RUP/00-requisitos/01-casos-de-uso
ls -la ../../../images/RUP/00-requisitos/01-casos-de-uso/diagrama-contexto-musico.svg
```

## ¿Alternativas?

**git filter-branch**

```bash
git filter-branch --subdirectory-filter docs/music/cQuintas -- --all
```

Descartado: deprecated, comportamiento no determinista en edge cases, documentación incompleta sobre preservación de metadatos.

**git filter-repo**

```bash
git filter-repo --path docs/music/cQuintas --path images/music/cQuintas
```

Descartado: requiere instalación adicional no disponible en sistema.

**git subtree split**

```bash
git subtree split --prefix=docs/music/cQuintas -b cquintas-branch
```

Descartado: no permite reorganización estructural durante extracción, requiere operaciones posteriores complejas para mover archivos.

## ¿Y ahora qué?

### Adaptación a otros proyectos

Modificar variables en script:

```bash
ORIGINAL_REPO="/ruta/al/repo/original"
NEW_REPO="/ruta/al/nuevo/repo"
```

Actualizar patrones de búsqueda:

```bash
git log --reverse --pretty=format:"%H %s" -- "ruta/proyecto" > commits.txt
```

Ajustar reorganización de estructura según necesidades del proyecto destino.

### Publicación

```bash
cd /home/manuel/misRepos/pyProgresionesArmonicas

# Crear repositorio en GitHub (interfaz web)
git remote add origin git@github.com:usuario/pyProgresionesArmonicas.git
git branch -M main
git push -u origin main
```

### Finalmente

- **Preservación de historial completo**: 18 commits identificados en repositorio fuente se reconstruyen como 17 commits en destino, más 2 commits de reorganización estructural, manteniendo orden cronológico, autoría y timestamps.

- **Reorganización de estructura**: `docs/music/cQuintas/*` se convierte en raíz del nuevo repositorio sin perder trazabilidad del cambio. Las rutas de imágenes en archivos markdown se corrigen automáticamente mediante `sed`.

- **Independencia de herramientas no estándar**: proceso utiliza únicamente comandos Git core (`log`, `archive`, `commit`) y utilidades Unix estándar (`tar`, `sed`, `find`).

- **Reproducibilidad**: script bash captura proceso completo, permite aplicación a otros proyectos modificando variables de configuración.

- **Verificabilidad**: cada commit reconstruido puede inspeccionarse con `git show`, compararse con original mediante hash de contenido.


### Limitaciones conocidas

**No preserva merge commits**: solo commits lineales se reconstruyen, merges complejos se aplanan.

**Hashes de commit diferentes**: inevitable al reescribir historial, referencias por hash desde documentación externa quedan inválidas.

**Proceso lento**: extracción commit por commit, pero aceptable para historial <100 commits.

---

**Proyecto extraído**: pyProgresionesArmonicas  
**Commits preservados**: 19 (17 históricos + 2 reorganización)  
**Fecha**: 2025-12-11