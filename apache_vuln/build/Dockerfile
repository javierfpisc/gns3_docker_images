ARG BASE_IMAGE=debian

FROM ${BASE_IMAGE}

#3ARG APACHE_VERSION

ENV TERM=xterm
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

LABEL maintainer=javierfp@iessanclemente.net

#Copiar el website vulnerable
COPY vulnerable-site/ /usr/local/apache2/htdocs/vulnerable-site/
COPY vulnerable-site/vulnerable.conf /usr/local/apache2/conf/extra/vulnerable.conf

#Copiar el script de instalación y lo
COPY install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh
#RUN /usr/local/bin/install.sh ${APACHE_VERSION}
RUN /usr/local/bin/install.sh

#Copiamos el entrypoint.sh al container
COPY entrypoint.sh /usr/bin/entrypoint.sh

#Damos permiso al entrypoint
RUN chmod +x /usr/bin/entrypoint.sh

#Comando para arrancar ssh y entrar en bucle de espera
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
