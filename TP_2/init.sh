#!/bin/bash

echo "Creando estructura de carpetas para el proyecto EjPractico2..."

# Crear la estructura básica del proyecto
mkdir -p TP2/static/css
mkdir -p TP2/static/images
mkdir -p TP2/templates
mkdir -p TP2/src


# Cambiar al directorio del proyecto
cd TP2

# Inicializar un proyecto con Pipenv e instalar Flask
echo "Inicializando Pipenv e instalando Flask..."
pipenv install flask

# Crear un archivo app.py vacío
echo "Creando app.py inicial..."
touch src/app.py

# Volver al directorio original
cd ..

echo "Configuración completa. La estructura del proyecto ha sido creada correctamente."
echo "Para ejecutar la aplicación, siga estos pasos:"
echo "1. cd TP2"
echo "2. pipenv shell"
echo "3. cd src"
echo "4. python app.py"