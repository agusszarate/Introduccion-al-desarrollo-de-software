#!/bin/bash

FILENAME=${FILENAME:-"alumnos.txt"}

DIRECTORIO_ENTORNO="EPNro1"
DIRECTORIO_ENTRADA="$DIRECTORIO_ENTORNO/entrada"
DIRECTORIO_SALIDA="$DIRECTORIO_ENTORNO/salida"
DIRECTORIO_PROCESADO="$DIRECTORIO_ENTORNO/procesado"

VERDE="\033[0;32m"
ROJO="\033[0;31m"
SIN_COLOR="\033[0m"

TIEMPO_SLEEP=5

procesar_archivo() {
    archivo=$1
    echo "" >> "$DIRECTORIO_SALIDA/$FILENAME"
    cat "$DIRECTORIO_ENTRADA/$archivo" >> "$DIRECTORIO_SALIDA/$FILENAME"
    mv "$DIRECTORIO_ENTRADA/$archivo" "$DIRECTORIO_PROCESADO"
}


while true; do
    archivo=$(ls "$DIRECTORIO_ENTRADA"/*.txt 2>/dev/null | head -n 1)

    if [ -n "$archivo" ]; then
        procesar_archivo $(basename $archivo)
    else
        # echo_con_color $ROJO "No hay archivos para procesar"
        :
    fi

    sleep $TIEMPO_SLEEP
done
