#!/bin/bash

FILENAME=${FILENAME:-"alumnos.txt"}

DIRECTORIO_ENTORNO="EPNro1"
DIRECTORIO_ENTRADA="$DIRECTORIO_ENTORNO/entrada"
DIRECTORIO_SALIDA="$DIRECTORIO_ENTORNO/salida"
DIRECTORIO_PROCESADO="$DIRECTORIO_ENTORNO/procesado"

VERDE="\033[0;32m"
ROJO="\033[0;31m"
SIN_COLOR="\033[0m"

echo_con_color() {
    color=$1
    mensaje=$2
    echo -e "${color}${mensaje}${SIN_COLOR}"
}

crear_entorno() {
    echo_con_color $VERDE "Creando el entorno en $DIRECTORIO_ENTORNO"
    mkdir -p $DIRECTORIO_ENTRADA $DIRECTORIO_SALIDA $DIRECTORIO_PROCESADO
    echo_con_color $VERDE "Entorno creado"
}

correr_proceso() {
    echo_con_color $VERDE "Corriendo proceso"
    bash $DIRECTORIO_ENTORNO/consolidar.sh &
    echo_con_color $VERDE "Proceso corriendo en background"
    echo ""
}

mostrar_listado() {
    if [ -f "$DIRECTORIO_SALIDA/$FILENAME" ]; then
        echo_con_color $VERDE "Listado de alumnos ordenados por número de padrón:"
        sort -t $'\t' -k1,1 "$DIRECTORIO_SALIDA/$FILENAME"
    else
        echo_con_color $ROJO "No se encontró el archivo $FILENAME en $DIRECTORIO_SALIDA"
    fi
}

mostrar_notas_altas() {
    if [ -f "$DIRECTORIO_SALIDA/$FILENAME" ]; then
        echo_con_color $VERDE "Listado de los 10 alumnos con las notas más altas:"
        sort -t $'\t' -k4,4nr "$DIRECTORIO_SALIDA/$FILENAME" | head -n 10
    else
        echo_con_color $ROJO "No se encontró el archivo $FILENAME en $DIRECTORIO_SALIDA"
    fi
}

mostrar_datos_alumno() {
    read -p "Ingrese el número de padrón: " padron
    if [ -f "$DIRECTORIO_SALIDA/$FILENAME" ]; then
        echo_con_color $VERDE "Datos del alumno con número de padrón $padron:"
        grep "^$padron" "$DIRECTORIO_SALIDA/$FILENAME"
    else
        echo_con_color $ROJO "No se encontró el archivo $FILENAME en $DIRECTORIO_SALIDA"
    fi
}

eliminar_entorno() {
    echo_con_color $VERDE "Eliminando entorno"
    rm -rf $DIRECTORIO_ENTRADA
    rm -rf $DIRECTORIO_SALIDA
    rm -rf $DIRECTORIO_PROCESADO
    pkill -f "consolidar.sh"
    echo_con_color $VERDE "Entorno eliminado"
}

detener_proceso() {
    echo_con_color $VERDE "Deteniendo proceso"
    pkill -f "consolidar.sh"
    echo_con_color $VERDE "Proceso detenido"
}

menu() {
    echo "-------------------------------"
    echo "Seleccioná una opción:"
    echo "1. Crear entorno"
    echo "2. Correr proceso"
    echo "3. Mostrar listado"
    echo "4. Mostrar notas altas"
    echo "5. Mostrar datos de un alumno"
    echo "6. Salir"

    if [ "$1" == "-d" ]; then
        echo "7. Eliminar entorno y detener procesos"
        echo "8. Detener proceso"
    fi

    echo "-------------------------------"

    read -p "Opción: " opcion

    echo ""

    case $opcion in
        1)
            crear_entorno
            ;;
        2)
            correr_proceso
            ;;
        3)
            mostrar_listado
            ;;
        4)
            mostrar_notas_altas
            ;;
        5)
            mostrar_datos_alumno
            ;;
        6)
            detener_proceso
            exit 0
            ;;
        7)
            eliminar_entorno
            ;;
        8)
            detener_proceso
            ;;
        *)
            echo_con_color $ROJO "Opción inválida"
            ;;
    esac
    menu $1
}

menu $1