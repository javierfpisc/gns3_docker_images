ARG BASE_IMAGE=debian

FROM ${BASE_IMAGE}

ENV TERM=xterm
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

LABEL maintainer=javierfp@iessanclemente.net

#Copiar el script de instalación y lo
COPY install.sh /usr/local/bin/install.sh
RUN bash /usr/local/bin/install.sh

#Copiamos el entrypoint.sh al container
COPY entrypoint.sh /usr/bin/entrypoint.sh

#Damos permiso al entrypoint
RUN chmod +x /usr/bin/entrypoint.sh

#Comando para arrancar ssh y entrar en bucle de espera
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
