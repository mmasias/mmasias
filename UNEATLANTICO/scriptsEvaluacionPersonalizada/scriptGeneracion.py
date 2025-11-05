import os
import json
from github import Github
from anthropic import Anthropic

def generar_examenes(estudiantes, repo_name, github_token, anthropic_key):
    """
    Genera exámenes personalizados para lista de estudiantes.
    
    Parámetros:
    - estudiantes: lista de nombres/IDs
    - repo_name: nombre del repositorio (ej: "user/repo")
    - github_token: token de acceso a GitHub API
    - anthropic_key: API key de Anthropic para Claude
    """
    
    g = Github(github_token)
    repo = g.get_repo(repo_name)
    client = Anthropic(api_key=anthropic_key)
    
    examenes_generados = []
    
    for estudiante in estudiantes:
        print(f"Procesando: {estudiante}")
        
        # 1. Obtener PRs del estudiante
        prs = repo.get_pulls(state='all', head=estudiante)
        
        # 2. Extraer código de todos los PRs
        codigo_completo = []
        for pr in prs:
            archivos = pr.get_files()
            for archivo in archivos:
                if archivo.filename.endswith('.java'):
                    contenido = repo.get_contents(
                        archivo.filename, 
                        ref=pr.head.sha
                    ).decoded_content.decode()
                    
                    codigo_completo.append({
                        'archivo': archivo.filename,
                        'contenido': contenido,
                        'pr_number': pr.number,
                        'commit_sha': pr.head.sha
                    })
        
        # 3. Analizar código con LLM
        prompt = construir_prompt_analisis(codigo_completo)
        
        response = client.messages.create(
            model="claude-sonnet-4-20250514",
            max_tokens=4000,
            messages=[{"role": "user", "content": prompt}]
        )
        
        fragmentos = json.loads(response.content[0].text)
        
        # 4. Generar markdown del examen
        examen_md = generar_markdown_examen(
            estudiante, 
            fragmentos, 
            repo_name
        )
        
        # 5. Guardar archivo
        ruta = f"examenes/{estudiante}_examen.md"
        with open(ruta, 'w', encoding='utf-8') as f:
            f.write(examen_md)
        
        examenes_generados.append(ruta)
        print(f"  ✓ Examen generado: {ruta}")
    
    return examenes_generados

def construir_prompt_analisis(codigo_completo):
    """Construye el prompt para el LLM"""
    codigo_texto = "\n\n".join([
        f"=== {c['archivo']} ===\n{c['contenido']}" 
        for c in codigo_completo
    ])
    
    return f"""
    Analiza el siguiente código Java de un estudiante de programación nivel inicial.
    
    TAREA: Identificar 10 fragmentos de código que presenten oportunidades de reflexión.
    [... resto del prompt como se especificó anteriormente]
    
    CÓDIGO DEL ESTUDIANTE:
    {codigo_texto}
    
    FORMATO DE SALIDA: JSON con estructura {{\"fragmentos\": [...]}}
    """

def generar_markdown_examen(estudiante, fragmentos, repo_name):
    """Genera el markdown del examen a partir de los fragmentos"""
    md = f"# Examen Parcial Personalizado - {estudiante}\n\n"
    md += "## Instrucciones\n\n"
    md += "Se presentan 10 fragmentos extraídos de tu código...\n\n"
    md += "---\n\n"
    
    for i, frag in enumerate(fragmentos['fragmentos'][:10], 1):
        md += f"## Pregunta {i}\n\n"
        md += f"**Contexto:** {frag['archivo']}\n\n"
        md += f"**Código:**\n```java\n{frag['codigo']}\n```\n\n"
        md += f"**Enlace:** [{frag['commit_url']}]\n\n"
        md += "**¿Qué observas? ¿Es correcto o presenta algún problema?**\n\n"
        md += "---\n\n"
    
    return md

# Uso:
estudiantes = ["estudiante1", "estudiante2", ...]  # Lista completa
generar_examenes(
    estudiantes, 
    "mmasias/25-26-PRG1",
    github_token="ghp_xxx",
    anthropic_key="sk-ant-xxx"
)
