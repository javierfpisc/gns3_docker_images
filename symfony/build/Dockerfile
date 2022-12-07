FROM ubuntu:latest

ENV TERM xterm
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

LABEL distribucion="Ubuntu"
LABEL maintainer=javierfp@iessanclemente.net

#Argumento tomado del docker-compose.yml para seleccionar el archivo .env->envfile
ARG ENVPATH

#Copiamos el envfile al container
COPY ${ENVPATH} /tmp/envfile

#Copiamos el entrypoint.sh al container
COPY entrypoint.sh /usr/bin/entrypoint.sh

#Damos permiso al entrypoint
RUN chmod +x /usr/bin/entrypoint.sh

#Instalamos paquetes de utilidades del envfile
RUN /bin/bash -c 'source /tmp/envfile; apt update; apt install -y $PACKS'

#Ejecutamos lista de comandos del envfile
RUN /bin/bash -c 'source /tmp/envfile;IFS=',';for command in $COMMANDS;do sh -c $command;done'

#Limpiando
RUN apt clean

#Comando para arrancar ssh y entrar en bucle de espera
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
