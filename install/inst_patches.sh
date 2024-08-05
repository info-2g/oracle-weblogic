#!/bin/sh

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

PATCH_DIR=$HOME/forms_patches
#./tools/spbat/generic/SPBAT/spbat.sh -phase apply -oracle_home $ORACLE_HOME

# Recorre los subdirectorios y ejecuta el script en cada uno
for SUBDIR in ${PATCH_DIR}/3*/; do
    if [ -d "$SUBDIR" ]; then
        echo "Ingresando al subdirectorio $SUBDIR"
        cd "$SUBDIR" && ($ORACLE_HOME/OPatch/opatch apply -silent)
    fi
done

