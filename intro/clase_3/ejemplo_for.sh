
if [[ -z $(ls *.txt) ]]; then
    echo "No hay archivos en el directorio."
else
    for file in $(ls *.txt); do
        echo "====================="
        cat $file
        echo "====================="
    done
fi
