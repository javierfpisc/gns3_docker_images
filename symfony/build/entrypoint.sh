#!/bin/bash

#Borramos archivos para vaciar el directorio y que el comando composer no de fallo
rm -f /$PROJNAME/.env
rm -f /$PROJNAME/.gitignore

[ -d /$PROJNAME/src ] || composer create-project symfony/skeleton:${SYMFONYV} $PROJNAME

cd /$PROJNAME
symfony server:start

exec bash -c "while true;do sleep 10;done"

