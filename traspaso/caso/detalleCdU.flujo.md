@startuml
start
:Usuario solicita registrar nueva actividad;
:Sistema muestra categorías disponibles;

repeat
  :Usuario ingresa categoría;
  if (Categoría válida?) then (sí)

    :Sistema solicita valor de actividad;

    repeat
      :Usuario ingresa valor;
      if (Valor válido?) then (sí)

      :Sistema solicita fecha de actividad;

      repeat
        :Usuario ingresa fecha;
        if (Fecha válida?) then (sí)

          :Usuario solicita cálculo de huella;

          repeat
            if (Cálculo exitoso?) then (sí)
              :Sistema muestra resultado del cálculo;
              :Sistema muestra estadísticas actualizadas;
              if (Usuario alcanzó hito?) then (sí)
                :Sistema muestra notificación de logro;
              endif
              :Sistema muestra sugerencia personalizada;
              stop
            else (no)
              :Sistema muestra error;
              :Sistema solicita intentar de nuevo;
            endif
          repeat while (Usuario quiere intentar de nuevo?) is (sí)
          -> no;
          stop

        else (no)
          :Sistema muestra error;
          :Sistema solicita fecha válida;
        endif
      repeat while (Usuario quiere intentar de nuevo?) is (sí)
      -> no;
      stop

      else (no)
        :Sistema muestra error;
        :Sistema solicita valor válido;
      endif
    repeat while (Usuario quiere intentar de nuevo?) is (sí)
    -> no;
    stop



  else (no)
    :Sistema muestra error;
    :Sistema solicita categoría válida;
  endif
repeat while (Usuario quiere intentar de nuevo?) is (sí)
-> no;
stop







@enduml