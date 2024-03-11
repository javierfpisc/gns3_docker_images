#!/bin/bash

#Si se han definido rutas se cargan
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh


exec bash

