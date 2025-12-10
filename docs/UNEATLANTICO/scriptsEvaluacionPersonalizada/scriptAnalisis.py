import requests

def obtener_prs_estudiante(repo, estudiante, token):
    url = f"https://api.github.com/repos/{repo}/pulls"
    headers = {"Authorization": f"token {token}"}
    params = {"state": "all", "head": f"{estudiante}"}
    
    response = requests.get(url, headers=headers, params=params)
    return response.json()

def extraer_archivos_pr(repo, pr_number, token):
    url = f"https://api.github.com/repos/{repo}/pulls/{pr_number}/files"
    headers = {"Authorization": f"token {token}"}
    
    response = requests.get(url, headers=headers)
    return response.json()
