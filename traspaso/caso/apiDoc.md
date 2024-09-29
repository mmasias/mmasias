# OpenAPI

```
openapi: 3.0.0
info:
  title: EcoTrack API
  version: 1.0.0
  description: API para la aplicación EcoTrack de seguimiento de huella de carbono

paths:
  /carbon-footprint/calculate:
    post:
      summary: Calcula la huella de carbono de una actividad
      tags:
        - Carbon Footprint
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Activity'
      responses:
        '200':
          description: Cálculo exitoso
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CarbonFootprint'
        '400':
          description: Datos de entrada inválidos
        '500':
          description: Error del servidor

components:
  schemas:
    Activity:
      type: object
      required:
        - categoria
        - valor
        - fecha
      properties:
        categoria:
          type: string
          enum: [transporte_coche, transporte_bus, consumo_electrico, consumo_gas]
        valor:
          type: number
          description: Valor numérico de la actividad (ej. kilómetros, kWh)
        fecha:
          type: string
          format: date
          description: Fecha de la actividad (YYYY-MM-DD)
    
    CarbonFootprint:
      type: object
      properties:
        huella:
          type: number
          description: Huella de carbono calculada en kg de CO2
        fecha_calculo:
          type: string
          format: date-time
          description: Fecha y hora del cálculo
```
