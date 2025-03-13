ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ENV TERM=xterm
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

LABEL maintainer=javierfp@iessanclemente.net

#Copiar el script de instalación y lo
COPY install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh
RUN /usr/local/bin/install.sh

#Copiar el script de hardening
COPY hardening.sh /usr/local/bin/hardening.sh
RUN chmod +x /usr/local/bin/hardening.sh

#Copiamos el entrypoint.sh al container
COPY entrypoint.sh /usr/bin/entrypoint.sh

#Damos permiso al entrypoint
RUN chmod +x /usr/bin/entrypoint.sh

#Comando para arrancar ssh y entrar en bucle de espera
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
