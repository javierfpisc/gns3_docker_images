ARG BASE_IMAGE=debian

FROM ${BASE_IMAGE}

ARG FFUF_VERSION
ARG HTTPPROBE_VERSION
ARG OWASP_ZAP_VERSION

ENV TERM=xterm
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

LABEL maintainer=javierfp@iessanclemente.net

#Copiar el script de instalación
COPY install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh 

#Ejecutamos el script
RUN /usr/local/bin/install.sh ${FFUF_VERSION} ${HTTPPROBE_VERSION} ${OWASP_ZAP_VERSION}

#Copiamos el entrypoint.sh al container
COPY entrypoint.sh /usr/bin/entrypoint.sh

#Damos permiso al entrypoint
RUN chmod +x /usr/bin/entrypoint.sh

#Comando para arrancar ssh y entrar en bucle de espera
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
