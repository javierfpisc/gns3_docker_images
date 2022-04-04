#!/bin/bash

[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh

#Cuando se trate de un agente cargamos la key desde la variable de entorno CLIENT_KEY
[ -f /var/ossec/bin/agent-auth ] && yes | /var/ossec/bin/manage_agents -i $CLIENT_KEY

#Arranca ossec (server y agent)
/etc/init.d/ossec start

#Arranca mysql y apache2 (web ui server)
[ -f /etc/init.d/apache2 ] && /etc/init.d/apache2 start
[ -f /etc/init.d/mysql ] && /etc/init.d/mysql start

exec bash

