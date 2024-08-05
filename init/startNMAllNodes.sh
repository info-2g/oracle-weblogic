SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)
 
# Ruta al archivo environment.properties
PROPERTIES_FILE="${SCRIPT_PATH}/environment.properties"

# Script que deseas ejecutar en cada servidor remoto
REMOTE_SCRIPT="${SCRIPT_PATH}/startNM.sh"

# Verifica si el archivo environment.properties existe
if [ ! -f "$PROPERTIES_FILE" ]; then
    echo "El archivo '$PROPERTIES_FILE' no existe. Verifica la ruta."
    exit 1
fi

# Lee el parámetro p_servers del archivo environment.properties
p_servers=$(grep '^p_servers=' "$PROPERTIES_FILE" | cut -d'=' -f2)

# Verifica si p_servers está vacío
if [ -z "$p_servers" ]; then
    echo "No se encontró el parámetro 'p_servers' en '$PROPERTIES_FILE'."
    exit 1
fi

# Divide la lista de servidores por comas y recorre cada uno
IFS=',' read -r -a servers <<< "$p_servers"
for server in "${servers[@]}"; do
    echo "Conectando a $server..."

    # Conéctate al servidor y ejecuta el script remoto
    ssh "$server" "bash -s" < "$REMOTE_SCRIPT"

    if [ $? -eq 0 ]; then
        echo "El script se ejecutó exitosamente en $server."
    else
        echo "Error al ejecutar el script en $server."
    fi
done

