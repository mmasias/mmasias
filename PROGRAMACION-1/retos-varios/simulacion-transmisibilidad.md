# Simulación de transmisibilidad

> ***NOTA:*** *Esta actividad no tiene en absoluto un carácter científico, sino que se presenta como una simulación del tema de una enfermedad, su propagación y los factores que pueden ayudar a controlarla. Limitar –como es el caso del presente examen- el contagio a una actuación por día y el control del mismo al uso de una mascarilla es una simplificación debida a la limitante del tiempo del que se dispone para resolverlo, por lo que se anima a los estudiantes que lo deseen a extender esta simulación más allá del presente examen, de las restricciones académicas y de tiempo utilizado para resolverlo.*

Las enfermedades infecciosas son causadas por microorganismos patógenos como las bacterias, los virus, los parásitos o los hongos. Estas enfermedades pueden transmitirse, directa o indirectamente, de una persona a otra. 

En un momento dado, una persona puede estar sana o enferma. En el caso de estar sano, si entra en contacto con una persona enferma existe la probabilidad de ser contagiado, con capacidad de contagiar a otras personas a partir del momento inmediatamente posterior al contagio.

![](../../imagenes/transmisibilidad001.png)

La probabilidad de contagio se ha establecido en un 15 %: incluso con esta probabilidad relativamente baja, la propagación es bastante rápida. 

A continuación, nótese el efecto en una semana:

Situación al inicio: 2 enfermos
![](../../imagenes/transmisibilidad002.png)

Situación luego de una semana: 
79 enfermos en total, de los cuales 22 fueron contagiados ese día.
![](../../imagenes/transmisibilidad003.png)

## Reto 1

Desarrolle un programa que simule este escenario, asumiendo un total de 221 personas (219 sanas y 2 enfermas), dispuestas en un espacio de 21x17. Como se indica arriba, la probabilidad de contagio en cada ciclo es de un 15%: asuma que cada ciclo es igual a 1 día. El modelo, al final de cada día, ha de presentar un resumen de número de personas sanas, número de personas enfermas y numero de contagiadas en dicho ciclo. 

# Control de la propagación

La situación anteriormente presentada puede controlarse por varios medios. Uno de ellos es mediante el uso de [mascarillas](https://es.wikipedia.org/wiki/Mascarilla), las cuales correctamente utilizadas reducen el riesgo de transmisión de la infección. 

## Reto 2

Mejore la simulación anterior, implementando el uso de mascarillas. Asumamos que las personas que tiene mascarilla la utilizan adecuadamente el 98% de las veces. La probabilidad de contagio sigue siendo la misma para personas que no utilizan mascarilla y en los poquísimos casos en los que la mascarilla falla.

## Reto 3

Resueltos los retos 1 y 2, deje configurada la simulación de modo que se minimicen los contagios. Como única particularidad asuma que el punto de partida es de 5 personas enfermas. Explique y reflexione –en los comentarios del código fuente enviado- acerca de las razones de esta configuración.

# Sugerencias de presentación

![](../../imagenes/transmisibilidad004.png)


![](../../imagenes/transmisibilidad005.png)


![](../../imagenes/transmisibilidad006.png)

