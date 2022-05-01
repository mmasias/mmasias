# Interfaz, diseño por contrato e implantación
Apuntes de [esta clase](https://escuela.it/cursos/curso-de-diseno-orientado-a-objetos/clase/interfaz-diseno-por-contrato-e-implantacion)


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

### MENOR COMPROMISO / MENOR SORPRESA

-Ejemplo de Violacion: 
	- calcularFactorial(3) lo calcula y lo imprime por pantalla
- Cada metodo debe ser un unico verbo
- Este principio invita a la cohesión
	- Ejemplo del pedal del freno

---

### INTERFAZ SUFICIENTE / COMPLETA / PRIMITIVA
