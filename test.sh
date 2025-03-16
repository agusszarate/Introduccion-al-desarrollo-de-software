echo -n "Ingrese su edad: "
read edad

if [ $edad -lt 18 ]; then 
    echo "Eres menor de edad";
else
    echo "Eres mayor de edad";
fi