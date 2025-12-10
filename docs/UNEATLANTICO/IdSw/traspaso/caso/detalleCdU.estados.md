@startuml
[*] --> EsperandoSolicitud

state EsperandoSolicitud {
  [*] --> MostrandoCategorias : Usuario solicita registrar actividad
}

state IngresandoDatos {
  state "Solicitando Categoría" as SolicitandoCategoria
  state "Solicitando Valor" as SolicitandoValor
  state "Solicitando Fecha" as SolicitandoFecha
  
  SolicitandoCategoria --> SolicitandoValor : Categoría válida
  SolicitandoValor --> SolicitandoFecha : Valor válido
  SolicitandoFecha --> DatosCompletos : Fecha válida
  
  SolicitandoCategoria --> SolicitandoCategoria : Categoría inválida
  SolicitandoValor --> SolicitandoValor : Valor inválido
  SolicitandoFecha --> SolicitandoFecha : Fecha inválida
}

MostrandoCategorias --> IngresandoDatos

state Calculando {
  state "Procesando Cálculo" as ProcesandoCalculo
  state "Preparando Resultados" as PreparandoResultados
  
  ProcesandoCalculo --> PreparandoResultados : Cálculo exitoso
  ProcesandoCalculo --> ProcesandoCalculo : Error en cálculo
}

DatosCompletos --> Calculando : Usuario solicita cálculo

state MostrandoResultados {
  state "Mostrando Huella" as MostrandoHuella
  state "Actualizando Estadísticas" as ActualizandoEstadisticas
  state "Verificando Logros" as VerificandoLogros
  state "Generando Sugerencias" as GenerandoSugerencias
  
  MostrandoHuella --> ActualizandoEstadisticas
  ActualizandoEstadisticas --> VerificandoLogros
  VerificandoLogros --> GenerandoSugerencias
}

PreparandoResultados --> MostrandoResultados

MostrandoResultados --> EsperandoSolicitud : Proceso completado

EsperandoSolicitud --> [*] : Usuario sale del sistema

@enduml