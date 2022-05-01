# Interfaz, diseño por contrato e implantación
Mis apuntes de [esta clase](https://escuela.it/cursos/curso-de-diseno-orientado-a-objetos/clase/interfaz-diseno-por-contrato-e-implantacion)

### Introducción
- Diseñar es dar forma
- Pero hay que dar forma de distintas piezas
- Las piezas deben ser de alta cohesión, bajo acoplamiento y tamaño pequeño
	- El 1 es el todo de muchos: al abrir un uno, vemos muchos. Por tanto debe de haber cohesión
	- El 1 depende de todos con los que colabore
- Los dos puntos de vista anteriores son lo mismo: Cohesión y Acoplamiento

---

- Antes de programar, diseñar las clases
- Repartir responsabilidades
- Establezco relaciones
- Repaso los nombres
- Código
- Vuelta arriba
---

- Los diagramas son para leer, no para abrumar
- No se hace diagramas de todo el código
- Los diagramas NO SON para documentar: son para ayudar a escribir mejor
- Son para ayudar a pensar
- Se hacen según se necesiten

xq? xq cuando el código esté hecho, entre otras cosas debe ser legible, inteligible

---
### INTERFAZ

- Nombres coherentes
- Hay que pulir / Revisar para reducir el numero de nombres mínimos
- Cuando ha terminado y funciona hay que ponerlo bien
- ¿Cada cosas está en su sitio?
- ¿Hay que mover las responsabilidadaes?
- Repasar / Revisar
---
### MENOR COMPROMISO / MENOR SORPRESA

-Ejemplo de Violacion: 
	- calcularFactorial(3) lo calcula y lo imprime por pantalla
- Cada metodo debe ser un unico verbo
- Este principio invita a la cohesión
	- Ejemplo del pedal del freno

---
### INTERFAZ SUFICIENTE / COMPLETA / PRIMITIVA

- Suficiente:  
- Completa:
- Primitiva: Ejemplo de la pila. La clase debe quedar primitiva

---
## Diseño por contrato

- Saber los límites del software para delimitar Excepcion o Assert
- Las piezas deben protegerse tanto como sea posible, sin exagerar
- Programacion defensiva es una forma inaecuada de gesstionarlo
	- IFs por todos lados
- Aserciones como forma correcta de gestionar
	- Reemplaza IFs por assert: condiciones
	- No es tratamiento de errores sino de despistes
	- Los assert se pueden habilitar o deshabilitar

### Definición
- Protocolo: vista pública de la clase y responsabilidades
	- Precondicion: antes de la acción
	- Postcondición: resultado
- Resultó efectivo el uso de precondiciones. Las poscondiciones fueron complejas de implementar. Se implementaron como pruebas: valores en pruebas.

Invariante de una clase: restriccion general a aplicar a cada objeto, junto con las precondiciones y poscondiciones
## COHESION
- Cohesión de métodos
- Principìo de única responsabilidad

No se cumple cuando

- Responsabilidad fuera de lugar
- Sin clase para una responsabilidad
- Clase sin responsabilidad

Entonces:

- Tener muchos motivos de cambios es consecuencia de la falta de cohesión

#### SMELL CODES relacionados
- **Envidia de características**: Una clase get o set a muchas clases para hacer cálculos... Igual el cálculo lo debía de hacer la otra clase.
- **Clase de datos**: Clases que no tienen responsabilidades (solo métodos get y/o set)
- **Cambios divergentes**: Muchos cambios se resuelven cambiando una única clase
- **Cirugia a escopetazos**: al tener la responsabilidad distribuida en muchas clases
- **Grupo de datos**: Muchos elementos similares en muchas clases: deberían componer su propio objeto (ejemplo fila-columna) 
- **Obsesión por tipos primitivos**: ejemplo [codigo postal](https://es.wikipedia.org/wiki/C%C3%B3digo_postal_de_Espa%C3%B1a)
- **Clase perezosa**: Una clase que no hace nada (ejemplo clase ficha)

---
A partir de aquí, [esta otra clase](https://escuela.it/cursos/curso-de-diseno-orientado-a-objetos/clase/principios-smell-codes-de-encapsulacion-y-tamano)

Es lícito diseño-programa-diseño-programa (para ir aprendiendo)

## ACOPLAMIENTO Y TAMAÑO
### Acomplamiento
- **Inapropiada intimidad**: No hagas cíclos, relaciones bidireccionales: "*Trabaja de forma jerárquica, no ciclica*"
	- Creando un nivel superior que "cosifique"
	- Extraer en una nueva clase
	- Excepción: ciclos con una interfaz
- **Leyes de Demeter**: "*No hables con extraños*"
- **Libreria imcompleta**: La clase debe encapsular la librería que expone la funcionalidad, exponiendola de forma cohesiva. Esto además resuelve/tieneQueVer con la cirugía a escopetazos. (La solución es el patrón *fachada*)
### Tamaño
- **Lista de parámetros larga**: 
	- Importante tener la asociación bien hecha desde el principio.
	- Hay clases y relaciones que salen *directas* del modelo del dominio
	- A veces, una clase perezosa puede ayudar aquí.
- **Métodos largos**: 
