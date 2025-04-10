#!/bin/bash

echo "Creando estructura de carpetas para el proyecto EjPractico2..."

mkdir -p TP2/static/css
mkdir -p TP2/static/images
mkdir -p TP2/templates
mkdir -p TP2/src
mkdir -p TP2/.venv

cd TP2

echo "Inicializando Pipenv e instalando Flask..."
pipenv install
pipenv install flask
pipenv install flask_mail
pipenv install dotenv

echo "Creando app.py inicial..."
touch src/app.py

cd ..

echo "Copiando archivos al directorio TP2..."
cp -r files/* TP2/
mv files/.env.example TP2/

cd TP2

echo "Iniciando el servidor Flask..."
cd src

pipenv run python3 app.py