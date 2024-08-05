#!/bin/bash

# Directorio fuente
source_dir="$HOME/scripts_forms"

# Archivo de propiedades
properties_file='../environment.properties'

# Leer el archivo de propiedades y extraer los servidores
servers=$(grep '^p_servers=' "$properties_file" | cut -d'=' -f2 | tr ',' '\n')

# Obtener el nombre del servidor local (puede ser la IP o el nombre de host)
local_server=$(hostname -f)

# Directorio destino en el servidor remoto
destination_dir=$HOME

# Copiar la carpeta 'init' a cada servidor, excluyendo el servidor local
for server in $servers; do
    # Limpiar espacios en blanco y caracteres extraños
    server=$(echo $server | xargs)

    # Verificar que el servidor no esté vacío
    if [ -n "$server" ]; then
        if [ "$server" != "$local_server" ]; then
            ssh $server 'rm -rf '$source_dir
            echo "Copiando a $server..."
            scp -r "$source_dir" "$server:$destination_dir"
        else
            echo "Excluyendo el servidor local: $server"
        fi
    else
        echo "Servidor vacío o inválido: $server"
    fi
done

echo "Copia completada."
