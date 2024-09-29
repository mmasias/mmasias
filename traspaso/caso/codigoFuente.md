# Código fuente

```
ecotrack/
│
├── src/
│   ├── services/
│   │   ├── __init__.py
│   │   ├── carbon_footprint_service.py
│   │   ├── recommendation_service.py
│   │   └── user_service.py
│   │
│   ├── models/
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── activity.py
│   │   └── carbon_footprint.py
│   │
│   ├── api/
│   │   ├── __init__.py
│   │   ├── routes.py
│   │   └── handlers/
│   │       ├── __init__.py
│   │       ├── user_handlers.py
│   │       └── activity_handlers.py
│   │
│   └── utils/
│       ├── __init__.py
│       └── helpers.py
│
├── tests/
│   ├── __init__.py
│   ├── test_carbon_footprint_service.py
│   └── test_recommendation_service.py
│
├── config/
│   └── .env
│
├── requirements.txt
└── README.md
```

## ecotrack/src/services/carbon_footprint_service.py
 
```python

import datetime
from typing import Dict

def calcular_huella_carbono(actividad: Dict[str, any]) -> float:
    """
    Calcula la huella de carbono para una actividad dada.
    
    :param actividad: Diccionario con los detalles de la actividad
    :return: Valor de la huella de carbono en kg de CO2
    """
    categoria = actividad['categoria']
    valor = actividad['valor']
    
    factores_emision = {
        'transporte_coche': 0.2,  # kg CO2 por km
        'transporte_bus': 0.1,    # kg CO2 por km
        'consumo_electrico': 0.5, # kg CO2 por kWh
        'consumo_gas': 0.2,       # kg CO2 por kWh
    }
    
    if categoria not in factores_emision:
        raise ValueError(f"Categoría de actividad no reconocida: {categoria}")
    
    huella = valor * factores_emision[categoria]
    
    # Aplicar ajustes basados en la fecha (ej. estación del año)
    fecha = actividad.get('fecha', datetime.date.today())
    if fecha.month in [12, 1, 2]:  # Invierno
        huella *= 1.1  # 10% más de emisiones en invierno
    
    return round(huella, 2)

# Ejemplo de uso
actividad_ejemplo = {
    'categoria': 'transporte_coche',
    'valor': 50,  # 50 km recorridos
    'fecha': datetime.date(2024, 1, 15)
}

huella = calcular_huella_carbono(actividad_ejemplo)
print(f"La huella de carbono de la actividad es: {huella} kg de CO2")

```

### ecotrack/config/.env

```ini

# Configuración de la aplicación
APP_NAME=EcoTrack
APP_ENV=development
APP_DEBUG=true
APP_URL=http://localhost:3000

# Configuración de la base de datos
DB_CONNECTION=mongodb
DB_HOST=localhost
DB_PORT=27017
DB_DATABASE=ecotrack
DB_USERNAME=ecotrack_user
DB_PASSWORD=your_strong_password

# Configuración del servidor
PORT=3000
NODE_ENV=development

# Claves de API (ejemplos, usar claves reales en producción)
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
WEATHER_API_KEY=your_weather_api_key

# Configuración de autenticación
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRATION=86400

# Configuración de servicios externos
CARBON_API_ENDPOINT=https://api.carbonintensity.org.uk
RECOMMENDATION_SERVICE_URL=http://localhost:5000

# Configuración de caché
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

# Configuración de logging
LOG_CHANNEL=stack
LOG_LEVEL=debug

# Configuración de email
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS=noreply@ecotrack.com
MAIL_FROM_NAME="${APP_NAME}"

# Configuración de almacenamiento
STORAGE_DRIVER=local

```
