# Control de entregas mediante GIT

El siguiente artículo propone un método para realizar un seguimiento de la entrega de trabajos mediante github y la hoja de cálculo de Google.

## Requisitos

Se requiere la lista de alumnos y, para cada uno de ellos, su correspondiente usuario de Github

## Uso

<div align=center>

`verificaPR(nombreUsuario, URLRepo, rama, diaLimite, horaLimite)`

</div>

La función `verificaPR()` devuelve TRUE o FALSE en función a si un usuario de github ha realizado un pull request a la rama de un repo. Se puede utilizar esta información combinándola con el resto de funciones de la hoja de cálculo para construir un enlace que se active únicamente si el usuario lo entregó bajo determinadas condiciones.

En la imagen inferior, para dos actividades, se pueden ver la lista de alumnos que han entregado a tiempo (columnas M y P), los que entregaron pero fuera de tiempo (columnas N y Q) y el enlace a las entregas de los que lo hicieron a tiempo (columnas O y R). Asimismo, información adicional en las columnas O y R como número de entregas, etc.

<div align=center>

|![](/imagenes/asistenciaGIT.png)
|-
|

</div>

## Configuración

Se propone que el encabezado de la actividad tenga la información requerida (en el ejemplo, la columna M):

- M2: Fecha límite de entrega
- M3: Hora límite de entrega
- M4: Rama de entrega

Y la celda A1 tenga la URL del repositorio

<div align=center>

![](/imagenes/Screenshot_20241003_165747.png)


</div>

Se pueden configurar columnas adicionales que permiten decisiones adicionales: en el ejemplo de arriba, la segunda columa del grupo de entrega (columna N) tiene una fecha muy futura (31/12/2024 en N2). Con esta configuración, podemos saber quién ha entregado a tiempo (en la columna M) y quién ha entregado fuera de tiempo (columna N)

## Código

```javascript
function verificaPR(nombreUsuario, URLRepo, rama, diaLimite, horaLimite) {
  try {
    var limite = obtenerFechaLimite(diaLimite, horaLimite);
    if (typeof limite === 'string') return limite;

    var [propietario, repositorio] = URLRepo.split('/').slice(-2);
    var apiUrl = `https://api.github.com/repos/${propietario}/${repositorio}/pulls?state=all&base=${rama}&per_page=100`;
    
    var response = UrlFetchApp.fetch(apiUrl, {
      headers: {
        'Authorization': 'Bearer _API_GITHUB_',
        'Accept': 'application/vnd.github.v3+json'
      },
      muteHttpExceptions: true
    });
    
    if (response.getResponseCode() !== 200) {
      return `Error en la API: ${response.getContentText()}`;
    }
    
    var pullRequests = JSON.parse(response.getContentText());
    var prsEncontrados = [];
    var nombreUsuarioLower = nombreUsuario.toLowerCase().replace(/\s+/g, '');
    
    for (var i = 0; i < pullRequests.length; i++) {
      var pr = pullRequests[i];
      var prUserLogin = pr.user.login.toLowerCase().replace(/\s+/g, '');
      if (prUserLogin.includes(nombreUsuarioLower) || nombreUsuarioLower.includes(prUserLogin)) {
        var fechaPR = new Date(pr.created_at);
        prsEncontrados.push(`PR #${pr.number} creado el ${fechaPR.toISOString()}`);
        if (fechaPR < limite) {
          return true;
        }
      }
    }
    
    return false;
  } catch (error) {
    return `Error general: ${error.toString()}`;
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