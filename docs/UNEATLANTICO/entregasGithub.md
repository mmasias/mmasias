# Control de entregas mediante GIT - v2.0

El siguiente artículo propone un método para realizar un seguimiento de la entrega de trabajos mediante github y la hoja de cálculo de Google.

## Requisitos

Se requiere la lista de alumnos y, para cada uno de ellos, su correspondiente usuario de Github.

Se requiere un token de acceso personal de GitHub con permisos de lectura sobre repositorios. Este token debe almacenarse en las propiedades del script de Google Apps Script con el nombre `GH_TOKEN`.

## Funciones disponibles

El sistema proporciona dos funciones principales:

### verificaPR

<div align=center>

`verificaPR(nombreUsuario, URLRepo, rama, diaLimite, horaLimite)`

</div>

Devuelve TRUE o FALSE en función a si un usuario de github ha realizado un pull request a la rama de un repo dentro del plazo establecido.

### hayComentarios

<div align=center>

`hayComentarios(nombreUsuario, URLRepo, rama)`

</div>

Devuelve TRUE o FALSE en función a si el profesor (propietario del repositorio) ha dejado comentarios de revisión en el pull request del alumno.

## Uso

La función `verificaPR()` se puede utilizar combinándola con el resto de funciones de la hoja de cálculo para construir un enlace que se active únicamente si el usuario lo entregó bajo determinadas condiciones.

En la imagen inferior, para dos actividades, se pueden ver la lista de alumnos que han entregado a tiempo (columnas O y S), los que entregaron pero fuera de tiempo (columnas P y T) y el enlace a las entregas de los que lo hicieron a tiempo (columnas R y V). Asimismo, las columnas Q y U indican si el profesor ha dejado algún comentario en el PR del alumno.

<div align=center>

|![](/images/asistenciaGIT.png)
|-
|

</div>

La función `hayComentarios()` permite verificar si se ha realizado la corrección del trabajo. Puede utilizarse en una columna adicional para identificar qué entregas han sido revisadas:

```
=IF(M6=TRUE; hayComentarios($J6; $A$1; M$4); "")
```

Esta fórmula solo verifica comentarios si la entrega fue válida.

## Configuración

### Token de GitHub

Se requiere configurar el token de acceso mediante el siguiente código ejecutado una única vez:

```javascript
function configurarToken() {
  PropertiesService.getScriptProperties().setProperty('GH_TOKEN', 'ghp_tu_token_aqui');
}
```

### Estructura de la hoja

Se propone que el encabezado de la actividad tenga la información requerida (en el ejemplo, la columna M):

- M2: Fecha límite de entrega
- M3: Hora límite de entrega
- M4: Rama de entrega

Y la celda A1 tenga la URL del repositorio

<div align=center>

![](/images/Screenshot_20241003_165747.png)

</div>

Se pueden configurar columnas adicionales que permiten decisiones adicionales: en el ejemplo de arriba, la segunda columna del grupo de entrega (columna N) tiene una fecha muy futura (31/12/2024 en N2). Con esta configuración, podemos saber quién ha entregado a tiempo (en la columna M) y quién ha entregado fuera de tiempo (columna N)

## Código

```javascript
function verificaPR(nombreUsuario, URLRepo, rama, diaLimite, horaLimite) {
  var validacion = validarParametros(nombreUsuario, URLRepo, rama, diaLimite, horaLimite);
  if (!validacion.valido) {
    return false;
  }
  
  try {
    var limite = obtenerFechaLimite(diaLimite, horaLimite);
    if (typeof limite === 'string') {
      return false;
    }
    
    var [propietario, repositorio] = URLRepo.split('/').slice(-2);
    var pullRequests = obtenerPRsDeRepositorio(propietario, repositorio, rama);
    
    if (typeof pullRequests === 'string') {
      return false;
    }
    
    return verificarPRDeUsuario(nombreUsuario, pullRequests, limite);
    
  } catch (error) {
    return false;
  }
}

function hayComentarios(nombreUsuario, URLRepo, rama) {
  if (!nombreUsuario || nombreUsuario.trim() === '') {
    return false;
  }
  
  try {
    var [propietario, repositorio] = URLRepo.split('/').slice(-2);
    var pullRequests = obtenerPRsDeRepositorio(propietario, repositorio, rama);
    
    if (typeof pullRequests === 'string') {
      return false;
    }
    
    var numeroPR = buscarNumeroPRDeUsuario(nombreUsuario, pullRequests);
    if (numeroPR === null) {
      return false;
    }
    
    return verificarComentariosEnPR(propietario, repositorio, numeroPR);
    
  } catch (error) {
    return false;
  }
}

function validarParametros(nombreUsuario, URLRepo, rama, diaLimite, horaLimite) {
  if (!nombreUsuario || nombreUsuario.trim() === '') {
    return {valido: false};
  }
  
  if (!URLRepo || URLRepo.trim() === '') {
    return {valido: false};
  }
  
  var segmentos = URLRepo.split('/').filter(s => s.trim() !== '');
  if (segmentos.length < 2) {
    return {valido: false};
  }
  
  if (!rama || rama.trim() === '') {
    return {valido: false};
  }
  
  return {valido: true};
}

function obtenerPRsDeRepositorio(propietario, repositorio, rama) {
  var token = PropertiesService.getScriptProperties().getProperty('GH_TOKEN');
  if (!token) {
    return 'Token de GitHub no configurado';
  }
  
  var apiUrl = `https://api.github.com/repos/${propietario}/${repositorio}/pulls?state=all&base=${rama}&per_page=100`;
  
  var response = UrlFetchApp.fetch(apiUrl, {
    headers: {
      'Authorization': `token ${token}`,
      'Accept': 'application/vnd.github.v3+json'
    },
    muteHttpExceptions: true
  });
  
  if (response.getResponseCode() !== 200) {
    return `Error en la API: ${response.getContentText()}`;
  }
  
  return JSON.parse(response.getContentText());
}

function verificarPRDeUsuario(nombreUsuario, pullRequests, limite) {
  var nombreUsuarioLower = nombreUsuario.toLowerCase().trim().replace(/\s+/g, '');
  
  for (var i = 0; i < pullRequests.length; i++) {
    var pr = pullRequests[i];
    var prUserLogin = pr.user.login.toLowerCase().trim().replace(/\s+/g, '');
    
    if (prUserLogin === nombreUsuarioLower) {
      var fechaPR = new Date(pr.created_at);
      if (fechaPR <= limite) {
        return true;
      }
    }
  }
  
  return false;
}

function buscarNumeroPRDeUsuario(nombreUsuario, pullRequests) {
  var nombreUsuarioLower = nombreUsuario.toLowerCase().trim().replace(/\s+/g, '');
  
  for (var i = 0; i < pullRequests.length; i++) {
    var pr = pullRequests[i];
    var prUserLogin = pr.user.login.toLowerCase().trim().replace(/\s+/g, '');
    
    if (prUserLogin === nombreUsuarioLower) {
      return pr.number;
    }
  }
  
  return null;
}

function verificarComentariosEnPR(propietario, repositorio, numeroPR) {
  var token = PropertiesService.getScriptProperties().getProperty('GH_TOKEN');
  if (!token) {
    return false;
  }
  
  var headers = {
    'Authorization': `token ${token}`,
    'Accept': 'application/vnd.github.v3+json'
  };
  
  var comentariosRevision = obtenerComentariosAPI(
    `https://api.github.com/repos/${propietario}/${repositorio}/pulls/${numeroPR}/comments`,
    headers
  );
  
  var comentariosGenerales = obtenerComentariosAPI(
    `https://api.github.com/repos/${propietario}/${repositorio}/issues/${numeroPR}/comments`,
    headers
  );
  
  return (
    tieneComentariosDelProfesor(comentariosRevision, propietario) ||
    tieneComentariosDelProfesor(comentariosGenerales, propietario)
  );
}

function tieneComentariosDelProfesor(comentarios, propietario) {
  var propietarioLower = propietario.toLowerCase().trim();
  
  for (var i = 0; i < comentarios.length; i++) {
    var autorComentario = comentarios[i].user.login.toLowerCase().trim();
    if (autorComentario === propietarioLower) {
      return true;
    }
  }
  
  return false;
}

function obtenerComentariosAPI(url, headers) {
  try {
    var response = UrlFetchApp.fetch(url, {
      headers: headers,
      muteHttpExceptions: true
    });
    
    if (response.getResponseCode() !== 200) {
      return [];
    }
    
    return JSON.parse(response.getContentText());
  } catch (error) {
    return [];
  }
}

function obtenerFechaLimite(diaLimite, horaLimite) {
  var limite;
  
  if (diaLimite instanceof Date && horaLimite instanceof Date) {
    limite = new Date(diaLimite.getFullYear(), diaLimite.getMonth(), diaLimite.getDate(),
                      horaLimite.getHours(), horaLimite.getMinutes(), horaLimite.getSeconds());
  } else if (typeof diaLimite === 'string' && typeof horaLimite === 'string') {
    if (!/^\d{4}-\d{2}-\d{2}$/.test(diaLimite)) {
      return `Error: Formato de fecha inválido. Use YYYY-MM-DD. Recibido: ${diaLimite}`;
    }
    if (!/^\d{2}:\d{2}:\d{2}$/.test(horaLimite)) {
      return `Error: Formato de hora inválido. Use HH:mm:ss. Recibido: ${horaLimite}`;
    }
    limite = new Date(diaLimite + 'T' + horaLimite + 'Z');
  } else {
    return `Error: Formato de fecha/hora inválido. Use YYYY-MM-DD y HH:mm:ss o objetos Date.`;
  }
  
  if (isNaN(limite.getTime())) {
    return `Error: Fecha/hora límite inválida. Recibido: ${diaLimite} ${horaLimite}`;
  }
  
  return limite;
}
```

## Notas técnicas

- La comparación de nombres de usuario es exacta después de normalización (minúsculas, sin espacios)
- La verificación de comentarios solo detecta comentarios del propietario del repositorio
- El sistema verifica tanto comentarios de revisión en código como comentarios generales
- La paginación está limitada a 100 PRs por rama
- Los timestamps se interpretan en UTC cuando se usan strings con formato ISO
