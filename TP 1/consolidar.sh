#!/bin/bash

while true; do
    for file in ~/EPNro1/entrada/*.txt; do
        [[ -e "$file" ]] || continue
        echo "Processing $file..."
        cat "$file" >> ~/EPNro1/salida/${FILENAME}.txt
        mv "$file" ~/EPNro1/procesado/
    done
    sleep 5
done
