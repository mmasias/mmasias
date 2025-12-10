# Sistema de automatización (modular) para evaluación de trabajos

## Arquitectura del sistema

### Repo Central: `evaluacion-automatica-utils`

Este repositorio contiene toda la lógica de automatización y se aloja en tu cuenta personal de GitHub.

#### Estructura del repo central

```
evaluacion-automatica-utils/
├── scripts/
│   ├── validador-estructura.py
│   ├── validador-java.py
│   ├── validador-plantuml.py
│   └── generador-feedback.py
├── configs/
│   ├── criterios-prg1.json
│   ├── criterios-prg2.json
│   ├── criterios-eda1.json
│   ├── criterios-eda2.json
│   ├── criterios-idsw1.json
│   └── criterios-idsw2.json
├── templates/
│   └── feedback-messages.json
└── README.md
```

#### Script principal de validación

**`scripts/validador-estructura.py`**
```python
#!/usr/bin/env python3
import json
import os
import sys
from pathlib import Path

def cargar_configuracion(asignatura, repo_config):
    """Carga la configuración específica de la asignatura"""
    config_path = f"configs/criterios-{asignatura.lower()}.json"
    
    # Descargar config desde el repo central
    import urllib.request
    config_url = f"https://raw.githubusercontent.com/TU_USUARIO/evaluacion-automatica-utils/main/{config_path}"
    
    with urllib.request.urlopen(config_url) as response:
        criterios_base = json.loads(response.read().decode())
    
    # Combinar con configuración específica del repo
    criterios_base.update(repo_config)
    return criterios_base

def validar_estructura_carpetas(criterios):
    """Valida que existan las carpetas requeridas"""
    errores = []
    carpetas_requeridas = criterios.get("carpetas_requeridas", [])
    
    for carpeta in carpetas_requeridas:
        if not Path(carpeta).exists():
            errores.append(f"❌ Falta la carpeta requerida: {carpeta}")
        else:
            print(f"✅ Carpeta encontrada: {carpeta}")
    
    return errores

def validar_archivos_obligatorios(criterios):
    """Valida que existan los archivos obligatorios"""
    errores = []
    archivos_requeridos = criterios.get("archivos_requeridos", [])
    
    for archivo in archivos_requeridos:
        if not Path(archivo).exists():
            errores.append(f"❌ Falta el archivo requerido: {archivo}")
        else:
            print(f"✅ Archivo encontrado: {archivo}")
    
    return errores

def validar_nomenclatura(criterios):
    """Valida nomenclatura de archivos según patrones"""
    errores = []
    patrones = criterios.get("patrones_nomenclatura", {})
    
    for patron, descripcion in patrones.items():
        archivos = list(Path().glob(patron))
        if not archivos:
            errores.append(f"❌ No se encontraron archivos que sigan el patrón: {patron} ({descripcion})")
    
    return errores

def main():
    # Leer configuración del repo actual
    with open('.github/evaluacion-config.json', 'r') as f:
        repo_config = json.load(f)
    
    asignatura = repo_config['asignatura']
    criterios = cargar_configuracion(asignatura, repo_config)
    
    print(f"🔍 Iniciando validación para {asignatura}")
    print("=" * 50)
    
    todos_los_errores = []
    
    # Ejecutar validaciones
    todos_los_errores.extend(validar_estructura_carpetas(criterios))
    todos_los_errores.extend(validar_archivos_obligatorios(criterios))
    todos_los_errores.extend(validar_nomenclatura(criterios))
    
    if todos_los_errores:
        print("\n💥 ERRORES ENCONTRADOS:")
        for error in todos_los_errores:
            print(error)
        
        # Crear comentario para el PR
        comentario = generar_comentario_rechazo(todos_los_errores, asignatura)
        with open('pr_comment.txt', 'w') as f:
            f.write(comentario)
        
        sys.exit(1)
    else:
        print("\n🎉 ¡Todas las validaciones pasaron correctamente!")
        
        comentario = generar_comentario_aprobacion(asignatura)
        with open('pr_comment.txt', 'w') as f:
            f.write(comentario)

def generar_comentario_rechazo(errores, asignatura):
    return f"""## ❌ Validación Automática Fallida - {asignatura.upper()}

Tu trabajo no cumple con algunos requisitos básicos. Por favor, corrige los siguientes problemas y vuelve a hacer el pull request:

### Errores Encontrados:
{chr(10).join(['- ' + error for error in errores])}

### 📝 Recordatorio:
- Revisa la estructura de carpetas del template
- Verifica que todos los archivos requeridos estén presentes
- Asegúrate de seguir las convenciones de nomenclatura

Una vez corregidos estos problemas, puedes cerrar este PR, hacer los cambios en tu rama, y crear un nuevo PR.

---
*Validación automática realizada por el sistema de evaluación de {asignatura}*
"""

def generar_comentario_aprobacion(asignatura):
    return f"""## ✅ Validación Automática Exitosa - {asignatura.upper()}

¡Excelente! Tu trabajo cumple con todos los requisitos estructurales básicos.

### Validaciones Completadas:
- ✅ Estructura de carpetas correcta
- ✅ Archivos obligatorios presentes
- ✅ Nomenclatura adecuada

Tu trabajo ahora será revisado manualmente por el profesor.

---
*Validación automática realizada por el sistema de evaluación de {asignatura}*
"""

if __name__ == "__main__":
    main()
```

#### Configuraciones por asignatura

**`configs/criterios-prg1.json`**
```json
{
    "asignatura": "PRG1",
    "carpetas_requeridas": [
        "src",
        "documents",
        "images"
    ],
    "archivos_requeridos": [
        "README.md",
        "src/Main.java"
    ],
    "patrones_nomenclatura": {
        "src/*.java": "Archivos Java en carpeta src",
        "README.md": "Archivo README principal"
    },
    "validaciones_adicionales": [
        "compilacion_java"
    ]
}
```

**`configs/criterios-prg2.json`**
```json
{
    "asignatura": "PRG2",
    "carpetas_requeridas": [
        "src",
        "documents",
        "images",
        "modelosUML"
    ],
    "archivos_requeridos": [
        "README.md",
        "src/Main.java"
    ],
    "patrones_nomenclatura": {
        "src/**/*.java": "Archivos Java organizados en paquetes",
        "modelosUML/*.puml": "Diagramas UML en formato PlantUML",
        "images/*.svg": "Diagramas exportados en formato SVG"
    },
    "validaciones_adicionales": [
        "compilacion_java",
        "validacion_oop",
        "generacion_plantuml"
    ]
}
```

**`configs/criterios-eda1.json`**
```json
{
    "asignatura": "EDA1",
    "carpetas_requeridas": [
        "src",
        "documents",
        "images",
        "modelosUML",
        "tests"
    ],
    "archivos_requeridos": [
        "README.md",
        "src/Main.java"
    ],
    "patrones_nomenclatura": {
        "src/**/*.java": "Archivos Java organizados en paquetes",
        "modelosUML/*.puml": "Diagramas UML",
        "tests/**/*Test.java": "Tests unitarios"
    },
    "validaciones_adicionales": [
        "compilacion_java",
        "validacion_oop",
        "validacion_estructuras_datos",
        "ejecucion_tests"
    ]
}
```

### Configuración en cada repo

Cada repo de asignatura necesita solo **2 archivos**:

#### 1. Archivo de configuración específica

**`.github/evaluacion-config.json`**
```json
{
    "asignatura": "PRG1",
    "curso": "24-25",
    "ramas_entrega": [
        "entrega-001",
        "entrega-002",
        "entrega-003"
    ],
    "validaciones_personalizadas": {
        "permitir_warnings": false,
        "timeout_compilacion": 30,
        "encoding": "UTF-8"
    }
}
```

#### 2. GitHub action

**`.github/workflows/evaluacion-automatica.yml`**
```yaml
name: Evaluación Automática

on:
  pull_request:
    branches: 
      - 'entrega-*'

jobs:
  validacion:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout del trabajo del estudiante
      uses: actions/checkout@v4
      with:
        fetch-depth: 0
    
    - name: Descargar herramientas de validación
      run: |
        curl -H "Authorization: token ${{ secrets.GITHUB_TOKEN }}" \
             -H "Accept: application/vnd.github.v3.raw" \
             -o validador.py \
             -L https://api.github.com/repos/${{ github.repository_owner }}/evaluacion-automatica-utils/contents/scripts/validador-estructura.py
        
        chmod +x validador.py
    
    - name: Configurar Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'
    
    - name: Configurar Java
      uses: actions/setup-java@v4
      with:
        java-version: '17'
        distribution: 'temurin'
    
    - name: Ejecutar validaciones
      id: validacion
      run: |
        python validador.py
      continue-on-error: true
    
    - name: Comentar resultado en PR
      uses: actions/github-script@v7
      with:
        script: |
          const fs = require('fs');
          let comentario = '';
          
          try {
            comentario = fs.readFileSync('pr_comment.txt', 'utf8');
          } catch (error) {
            comentario = '⚠️ Error al generar el comentario de validación.';
          }
          
          await github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.repo,
            body: comentario
          });
    
    - name: Fallar si hay errores de validación
      if: steps.validacion.outcome == 'failure'
      run: |
        echo "❌ La validación automática ha fallado. Revisa los comentarios del PR."
        exit 1
```

### Scripts adicionales del repo central

#### Validador Java

**`scripts/validador-java.py`**
```python
#!/usr/bin/env python3
import subprocess
import os
from pathlib import Path

def compilar_java():
    """Compila todos los archivos Java del proyecto"""
    archivos_java = list(Path("src").rglob("*.java"))
    
    if not archivos_java:
        return False, "No se encontraron archivos Java para compilar"
    
    try:
        # Crear directorio de compilación
        Path("build").mkdir(exist_ok=True)
        
        # Compilar todos los archivos Java
        cmd = ["javac", "-d", "build", "-cp", "src"] + [str(f) for f in archivos_java]
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode == 0:
            return True, "Compilación exitosa"
        else:
            return False, f"Errores de compilación:\n{result.stderr}"
    
    except Exception as e:
        return False, f"Error durante la compilación: {str(e)}"

def ejecutar_main():
    """Intenta ejecutar la clase Main del proyecto"""
    try:
        result = subprocess.run(
            ["java", "-cp", "build", "Main"], 
            capture_output=True, 
            text=True, 
            timeout=10
        )
        
        if result.returncode == 0:
            return True, f"Ejecución exitosa:\n{result.stdout}"
        else:
            return False, f"Error en ejecución:\n{result.stderr}"
    
    except subprocess.TimeoutExpired:
        return False, "La ejecución excedió el tiempo límite (10 segundos)"
    except Exception as e:
        return False, f"Error durante la ejecución: {str(e)}"

if __name__ == "__main__":
    print("🔨 Compilando código Java...")
    compilacion_ok, mensaje_compilacion = compilar_java()
    
    if not compilacion_ok:
        print(f"❌ {mensaje_compilacion}")
        exit(1)
    
    print(f"✅ {mensaje_compilacion}")
    
    print("🚀 Ejecutando programa...")
    ejecucion_ok, mensaje_ejecucion = ejecutar_main()
    
    if ejecucion_ok:
        print(f"✅ {mensaje_ejecucion}")
    else:
        print(f"⚠️ {mensaje_ejecucion}")
        # Para PRG1, un warning es suficiente
        # Para asignaturas avanzadas, podría ser error crítico
```

## Implementación y uso

### Paso 1: crear el repo central

1. Crear repo `evaluacion-automatica-utils` en tu cuenta
2. Subir todos los scripts y configuraciones
3. Hacer el repo privado pero accesible para tus otros repos

### Paso 2: Configurar un repo de asignatura

Para cada repo anual nuevo:

1. **Copiar los 2 archivos de configuración**:
   - `.github/evaluacion-config.json`
   - `.github/workflows/evaluacion-automatica.yml`

2. **Ajustar la configuración**:
   ```json
   {
     "asignatura": "PRG2",  // ← Cambiar según la asignatura
     "curso": "25-26",      // ← Cambiar según el año
     "ramas_entrega": [     // ← Ajustar nombres si es necesario
       "entrega-001",
       "entrega-002"
     ]
   }
   ```

3. **¡Listo!** El sistema ya funciona automáticamente.

### Paso 3: mantenimiento

- **Actualizar criterios**: Solo editar en el repo central
- **Nuevas asignaturas**: Crear nuevo archivo de criterios
- **Cambios en lógica**: Solo modificar scripts centrales

## Beneficios del sistema

<div align=center>

|Para el profesor|Para los alumnos|Para el sistema|
|-|-|-|
|**Configuración de 2 minutos** por repo nuevo cada año|**Feedback inmediato** al hacer el PR|**Modularidad total** - cada parte es independiente|
|**Mantenimiento centralizado** de toda la lógica|**Instrucciones claras** sobre qué corregir|**Extensibilidad fácil** - agregar nuevas validaciones es trivial|
|**Escalabilidad infinita** para nuevas asignaturas|**Aprendizaje progresivo** de buenas prácticas|**Robustez** - fallos en una parte no afectan las otras|
|**Consistencia garantizada** entre todos los cursos||**Trazabilidad completa** - todo queda registrado automáticamente|

</div>

## Expansiones

Una vez funcionando el sistema básico, se pueden agregar fácilmente:

- **Validaciones de calidad de código** con Checkstyle
- **Tests automáticos** para verificar funcionalidad
- **Análisis de plagio** comparando entre estudiantes
- **Métricas avanzadas** exportadas a tu Google Sheets
- **Integración con LMS** para calificaciones automáticas
