#!/bin/bash

export FILENAME="alumnos"

# Buscar parámetro
if [[ $1 == "-d" ]]; then
    echo "Matando entorno y proceso..."
    
    # Buscar el PID del proceso usando ps -ef trae detalles
    # grep "consolidar.sh" para filtrar el proceso
    # grep -v grep para excluir el grep anterior
    # awk '{print $2}' para obtener el PID que seria la segunda columna
        #ps -ef | grep "consolidar.sh" | grep -v grep 
        #  501 34544     1   0 10:34PM ttys025    0:00.01 bash /Users/agustinzarate/EPNro1/consolidar.sh
    PID=$(ps -ef | grep "consolidar.sh" | grep -v grep | awk '{print $2}')
    
    # -n chequea que no sea vacio
    if [ -n "$PID" ]; then
        kill $PID
        echo "Proceso con PID $PID detenido."
    else
        echo "No se encontró el proceso consolidar.sh en ejecución."
    fi

    #rf forzar recursivamente la eliminación
    rm -rf ~/EPNro1
    exit 0
fi


SALIR=0
while [ $SALIR -eq 0 ]; do
    echo "Seleccione una opción:"
    echo "1) Crear entorno"
    echo "2) Correr proceso"
    echo "3) Listar alumnos ordenados por padrón"
    echo "4) Mostrar las 10 notas más altas"
    echo "5) Buscar datos por padrón"
    echo "6) Salir"
    read -p "Opción: " option

    case $option in
        1)
            echo "Creando entorno..."
            mkdir -p ~/EPNro1/{entrada,salida,procesado}

            #auto generar el script consolidar.sh

            ##while true? el profesor habló de investigar un ¿cron?

            ## << 'FIN' para marcar el fin del archivo
            # > path para crear el archivo
            cat << 'FIN' > ~/EPNro1/consolidar.sh
#!/bin/bash
FILENAME="alumnos"
while true; do
    for file in ~/EPNro1/entrada/*.txt; do
        [[ -e "$file" ]] || continue
        echo "Processing $file..."
        echo "" >> ~/EPNro1/salida/${FILENAME}.txt
        cat "$file" >> ~/EPNro1/salida/${FILENAME}.txt
        mv "$file" ~/EPNro1/procesado/
    done
    sleep 5
done
FIN
            echo "Entorno creado en ~/EPNro1."
            ;;
        2)
            echo "Ejecutando proceso en segundo plano..."

            #nohup hace que no se termine el proceso cuando se cierra la terminal
            #&> /dev/null redirige cualquier salida a la nada
            #& al final del comando hace que se ejecute en segundo plano
            nohup bash ~/EPNro1/consolidar.sh &> /dev/null &
            
            ;;
        3)
            #-f para verificar si el archivo existe
            if [[ -f ~/EPNro1/salida/${FILENAME}.txt ]]; then
                echo "Listando alumnos ordenados por padrón..."
                #-n indica que se ordena por numero
                #-k 1 indica que se ordena por la columna 1
                sort -n -k 1 ~/EPNro1/salida/${FILENAME}.txt
            else
                echo "El archivo ${FILENAME}.txt no existe en salida."
            fi
            ;;
        4)
            if [[ -f ~/EPNro1/salida/${FILENAME}.txt ]]; then
                echo "Mostrando las 10 notas más altas..."

                #k 5 para ordenar por la columna 5
                #n para ordenar numéricamente
                #head para mostrar solo las primeras 10 líneas
                #awk '{print $(NF), $0}' ~/EPNro1/salida/${FILENAME}.txt | sort -nr -k1,1 | cut -d' ' -f2- | head
                sort -nr -k 5 ~/EPNro1/salida/${FILENAME}.txt | head
            else
                echo "El archivo ${FILENAME}.txt no existe en salida."
            fi
            ;;
        5)
            #read con mensaje
            read -p "Ingrese Nro_Padrón: " padron

            if [[ -f ~/EPNro1/salida/${FILENAME}.txt ]]; then

                echo "Buscando Nro_Padrón $padron..."
                
                grep "$padron " ~/EPNro1/salida/${FILENAME}.txt || echo "No se encontraron datos para $padron."
            else
                echo "El archivo ${FILENAME}.txt no existe en salida."
            fi
            ;;
        6)
            echo "Saliendo..."
            SALIR=1
            ;;
        *)
            echo "Opción inválida. Por favor intente de nuevo."
            ;;
    esac
done
