# Auditoría de Repositorios Git

## ¿Qué hace?

`git_audit.sh` es un script de Bash que analiza un repositorio Git y genera un informe detallado en formato Markdown (`git_audit.md`) con métricas de contribución de cada autor.

El script está diseñado específicamente para:
- Evaluar la participación de estudiantes en proyectos colaborativos
- Consolidar contribuciones cuando un mismo autor usa diferentes nombres/ordenadores
- Detectar posibles anomalías en las fechas de commits
- Proporcionar métricas tanto generales como específicas por tipo de archivo

## ¿Cómo se usa?

### Ejecución básica

```bash
# Navegar al repositorio que quieres auditar
cd /ruta/al/repositorio/del/proyecto

# Ejecutar el script
bash /ruta/al/git_audit.sh
```

El script:
1. Sincroniza automáticamente todas las ramas remotas
2. Analiza todo el historial de commits
3. Genera un archivo `git_audit.md` en el directorio actual

### Configuración

En la cabecera del script puedes configurar:

```bash
SPECIFIC_EXTENSION="puml"
```

Define la extensión de archivo que quieres analizar en detalle (sin el punto). Si no quieres analizar ninguna extensión específica, déjalo en blanco: `SPECIFIC_EXTENSION=""`

## ¿Cómo funciona?

### Consolidación por email

El script agrupa todas las contribuciones por **dirección de email**, no por nombre de usuario. Esto significa que:

- Si un alumno usa "Juan Pérez" en un ordenador y "juanp" en otro, pero ambos con `juan@example.com`, **todas sus contribuciones se consolidan en una sola línea**.
- El nombre que aparece en el informe es el del commit más reciente de ese email.

### Proceso de análisis

1. **Sincronización**: Ejecuta `git fetch --all` para asegurar que se analizan todas las ramas
2. **Extracción de emails**: Identifica todos los emails únicos en el historial
3. **Cálculo de métricas**: Para cada email, calcula:
   - Número de commits
   - Días activos (días únicos con al menos un commit)
   - Líneas añadidas y eliminadas
   - Archivos únicos modificados
   - Commits sospechosos (fechas manipuladas)
4. **Ordenación**: Ordena los resultados por porcentaje de contribución (de mayor a menor)
5. **Formato**: Genera una tabla Markdown con todas las métricas

## Columnas de la tabla

### Autor
Nombre y email del contribuidor en formato: `Nombre <email@example.com>`

Si un mismo email aparece con diferentes nombres, se muestra el nombre más reciente.

### Commits
Número total de commits realizados por el autor.

Este es el indicador principal de actividad en el repositorio.

### Días activos
Cantidad de días diferentes en los que el autor realizó al menos un commit.

**Interpretación**:
- Un autor con 50 commits en 10 días activos trabajó de forma más concentrada
- Un autor con 50 commits en 40 días activos distribuyó mejor el trabajo

### % Contrib.
Porcentaje de commits del autor respecto al total del repositorio.

Se calcula como: `(commits del autor / total de commits) × 100`

### LA (Total)
**Líneas Añadidas** en todo el repositorio.

Incluye todas las líneas nuevas creadas por el autor en cualquier tipo de archivo.

Nota: Un valor `-` indica que no se añadieron líneas (poco común, pero posible en commits que solo eliminan archivos).

### LE (Total)
**Líneas Eliminadas** en todo el repositorio.

Incluye todas las líneas borradas por el autor en cualquier tipo de archivo.

### Archivos (Total)
Número de archivos únicos que el autor ha modificado (añadido, editado o eliminado).

**Interpretación**:
- Valores altos pueden indicar trabajo en muchas partes del proyecto
- Valores bajos y concentrados pueden indicar especialización

### LA (.extensión)
**Líneas Añadidas** en archivos con la extensión especificada.

Esta columna solo aparece si has configurado `SPECIFIC_EXTENSION` en el script.

Útil para evaluar trabajo específico en:
- `.puml` - Diagramas PlantUML
- `.java` - Código Java
- `.py` - Código Python
- `.md` - Documentación Markdown

### LE (.extensión)
**Líneas Eliminadas** en archivos con la extensión especificada.

### Archivos (.extensión)
Número de archivos únicos de la extensión especificada que el autor ha modificado.

### SOS
**Commits sospechosos** - Detecta posibles manipulaciones de fechas.

Cuenta commits donde la diferencia entre la fecha de autoría (`author date`) y la fecha de commit (`committer date`) es mayor a 1 día.

**¿Cuándo aparece un número aquí?**
- Commits realizados localmente pero enviados mucho después (normal)
- Commits con fechas manipuladas intencionalmente (sospechoso)
- Rebases o cherry-picks que alteran el historial

**¿Por qué es importante?**
- Un valor `-` indica comportamiento normal
- Valores altos pueden indicar trabajo acumulado sin sincronizar o manipulación de fechas para aparentar trabajo distribuido

## Interpretación de resultados

### Ejemplo de análisis

```markdown
| Autor | Commits | Días activos | % Contrib. | LA (Total) | LE (Total) | Archivos (Total) | LA (.puml) | LE (.puml) | Archivos (.puml) | SOS |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Ana García <ana@example.com> | 45 | 15 | 42.9% | 2350 | 180 | 28 | 980 | 120 | 12 | - |
| Bob Smith <bob@example.com> | 35 | 12 | 33.3% | 1800 | 950 | 42 | 420 | 80 | 8 | - |
| Carol Jones <carol@example.com> | 25 | 3 | 23.8% | 1200 | 50 | 15 | 50 | 10 | 2 | 18 |
```

**Análisis**:

- **Ana**: Mayor contribución (42.9%), buen ritmo de trabajo (15 días activos), enfoque en crear código (.puml)
- **Bob**: Segunda mayor contribución, modificó más archivos (42), balance entre añadir y eliminar código (refactorización)
- **Carol**: Tercera contribución, pero **ALERTA**: Solo 3 días activos con 25 commits y 18 commits sospechosos sugiere trabajo concentrado en poco tiempo o fechas manipuladas

### Señales de alerta

1. **Muchos commits en pocos días activos** + **SOS alto**: Posible manipulación de fechas
2. **Porcentaje muy bajo** con **muchos commits**: Trabajo en repo muy activo, contribución limitada
3. **Muchas líneas eliminadas**: Puede indicar refactorización (positivo) o eliminación de trabajo previo
4. **Archivos (.extensión) = 0** con **Commits > 0**: El alumno no trabajó en los archivos principales del proyecto

## Limitaciones

- **Commits de bots**: GitHub Actions, Dependabot, etc., también aparecen en el informe
- **Trabajo no commiteado**: El script solo ve lo que está en el historial de Git
- **Calidad vs. cantidad**: Más líneas de código no significa mejor código
- **Pair programming**: Si dos personas trabajan juntas pero solo una hace commit, solo esa aparecerá

## Notas técnicas

- El script usa `git log --all` para analizar TODAS las ramas, no solo la actual
- Los emails se extraen exactamente como aparecen en la configuración de Git del autor
- Las métricas de líneas ignoran archivos binarios y cambios en permisos
- El ordenamiento es numérico descendente por porcentaje de contribución
