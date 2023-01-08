# Versión 9: temas y colisiones

> [Versión 9](ArrayAsociativo009.java): Opción de temas (se activa con la letra **v**), como ayuda para el desarrollo de la detección de por dónde puede y no puede caminar. 

|Tema 0|Tema 1|Tema 2|Tema 3
|-|-|-|-
|![](/imagenes/ArrayAsociativoV9SKIN0.png)|![](/imagenes/ArrayAsociativoV9SKIN1.png)|![](/imagenes/ArrayAsociativoV9SKIN2.png)|![](/imagenes/ArrayAsociativoV9SKIN3.png)
|Full color|Sin color|Tiles puros|Matriz colisiones

* Lao temas 1 y 2 son similares en el concepto de parsear el mapa almacenado, con la diferencia de la inclusión del color. 
* El tema 2 muestra el mapa con los tiles tal y como los tiene almacenados el programa. 
* El tema 3 muestra la "matriz de colisiones", es decir, los puntos por los que no debería permitirse el paso al personaje.

De una forma básica (o sea, *hardcoded*) verifica si puede ir al sitio que le piden: no permite traspasar paredes ni agua. 

    Ideas para las siguientes versiones: 
    - Generalizarlo a un "medio de transporte"
    - ¿Incluir altura y profundidad?
    - ¿Poder crear un puente?