# Pruebas

## Plan de pruebas

### 1. Pruebas Unitarias

- Servicios de cálculo de huella de carbono
- Servicios de recomendaciones
- Funciones de utilidad y helpers

### 2. Pruebas de Integración

- Integración entre el servicio de cálculo y la base de datos
- Integración con APIs externas (ej. servicios de clima, mapas)
- Flujo completo de registro de actividad y cálculo de huella

### 3. Pruebas de API

- Endpoints de usuario (registro, login, perfil)
- Endpoints de actividades (crear, leer, actualizar, eliminar)
- Endpoints de reportes y estadísticas

### 4. Pruebas de Interfaz de Usuario

- Compatibilidad con diferentes dispositivos y tamaños de pantalla
- Flujos de navegación principales
- Visualización correcta de gráficos y estadísticas

### 5. Pruebas de Rendimiento

- Tiempos de respuesta de la API bajo carga
- Rendimiento de la base de datos con gran volumen de datos
- Escalabilidad del servicio de cálculo de huella

### 6. Pruebas de Seguridad

- Autenticación y autorización
- Protección contra inyección SQL y XSS
- Encriptación de datos sensibles

### 7. Pruebas de Usabilidad

- Facilidad de registro y onboarding
- Claridad en la presentación de datos de huella de carbono
- Efectividad de las recomendaciones personalizadas

### 8. Pruebas de Compatibilidad

- Diferentes versiones de iOS y Android
- Varios navegadores web para el panel de administración

### 9. Pruebas de Recuperación

- Comportamiento de la app en caso de pérdida de conexión
- Recuperación tras un fallo del servidor

### 10. Pruebas de Localización

- Correcta visualización de diferentes idiomas
- Adaptación a diferentes formatos de fecha y unidades de medida

### Cronograma

- Semana 1-2: Pruebas Unitarias y de Integración
- Semana 3-4: Pruebas de API y UI
- Semana 5: Pruebas de Rendimiento y Seguridad
- Semana 6: Pruebas de Usabilidad y Compatibilidad
- Semana 7: Pruebas de Recuperación y Localización
- Semana 8: Revisión y pruebas de regresión

![](/images/modelosUML/traspaso/caso/gantt.svg)

### Recursos Necesarios

- 2 Desarrolladores QA
- 1 Ingeniero de Performance
- 1 Especialista en Seguridad
- Dispositivos iOS y Android para pruebas
- Herramientas: JMeter para pruebas de carga, Selenium para automatización de UI

### Criterios de Aceptación

- 100% de las pruebas unitarias pasadas
- Tiempo de respuesta promedio de la API < 200ms
- 0 vulnerabilidades de seguridad críticas
- Puntuación de usabilidad > 4/5 en pruebas con usuarios

## Ejemplo de una prueba unitaria

```python
# Archivo: tests/test_carbon_footprint_service.py

import unittest
from datetime import date
from src.services.carbon_footprint_service import calcular_huella_carbono

class TestCarbonFootprintService(unittest.TestCase):

    def test_calculo_huella_coche(self):
        actividad = {
            'categoria': 'transporte_coche',
            'valor': 100,  # 100 km
            'fecha': date(2024, 6, 15)  # Verano
        }
        huella = calcular_huella_carbono(actividad)
        self.assertEqual(huella, 20.0)  # 100 km * 0.2 kg CO2/km

    def test_calculo_huella_coche_invierno(self):
        actividad = {
            'categoria': 'transporte_coche',
            'valor': 100,  # 100 km
            'fecha': date(2024, 1, 15)  # Invierno
        }
        huella = calcular_huella_carbono(actividad)
        self.assertEqual(huella, 22.0)  # (100 km * 0.2 kg CO2/km) * 1.1

    def test_calculo_huella_consumo_electrico(self):
        actividad = {
            'categoria': 'consumo_electrico',
            'valor': 200,  # 200 kWh
            'fecha': date(2024, 6, 15)
        }
        huella = calcular_huella_carbono(actividad)
        self.assertEqual(huella, 100.0)  # 200 kWh * 0.5 kg CO2/kWh

    def test_categoria_invalida(self):
        actividad = {
            'categoria': 'categoria_inexistente',
            'valor': 100,
            'fecha': date(2024, 6, 15)
        }
        with self.assertRaises(ValueError):
            calcular_huella_carbono(actividad)

if __name__ == '__main__':
    unittest.main()

```
