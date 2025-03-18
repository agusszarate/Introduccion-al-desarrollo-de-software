#!/bin/bash

export FILENAME=alumnos

# Check for optional parameter -d
if [[ $1 == "-d" ]]; then
    echo "Deleting environment and killing background processes..."
    rm -rf ~/EPNro1
    pkill -f consolidar.sh
    exit 0
fi

# Ensure FILENAME is set
if [[ -z "$FILENAME" ]]; then
    echo "Error: FILENAME environment variable is not set."
    exit 1
fi

# Display menu
while true; do
    echo "Select an option:"
    echo "1) Crear entorno"
    echo "2) Correr proceso"
    echo "3) Listar alumnos ordenados por padrón"
    echo "4) Mostrar las 10 notas más altas"
    echo "5) Buscar datos por padrón"
    echo "6) Salir"
    read -p "Option: " option

    case $option in
        1)
            echo "Creating environment..."
            mkdir -p ~/EPNro1/{entrada,salida,procesado}
            echo "Environment created at ~/EPNro1."
            ;;
        2)
            echo "Running background process..."
            nohup bash ~/EPNro1/consolidar.sh &>/dev/null &
            echo "Process running in background."
            ;;
        3)
            if [[ -f ~/EPNro1/salida/${FILENAME}.txt ]]; then
                echo "Listing students sorted by padrón..."
                sort -n ~/EPNro1/salida/${FILENAME}.txt
            else
                echo "File ${FILENAME}.txt does not exist in salida."
            fi
            ;;
        4)
            if [[ -f ~/EPNro1/salida/${FILENAME}.txt ]]; then
                echo "Displaying top 10 highest grades..."
                sort -k4 -nr ~/EPNro1/salida/${FILENAME}.txt | head -n 10
            else
                echo "File ${FILENAME}.txt does not exist in salida."
            fi
            ;;
        5)
            read -p "Enter Nro_Padrón: " padron
            if [[ -f ~/EPNro1/salida/${FILENAME}.txt ]]; then
                echo "Searching for Nro_Padrón $padron..."
                grep "^$padron " ~/EPNro1/salida/${FILENAME}.txt || echo "No data found for $padron."
            else
                echo "File ${FILENAME}.txt does not exist in salida."
            fi
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
