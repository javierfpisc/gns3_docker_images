#!/bin/bash

#Si se han definido rutas se cargan
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh

#Creación archivos ansible
if [ ! -f /etc/ansible/ansible.cfg ]
then
	echo [defaults] >> /etc/ansible/ansible.cfg
	echo inventory=/etc/ansible/hosts >> /etc/ansible/ansible.cfg
fi

[ -f /etc/ansible/hosts ] || touch /etc/ansible/hosts

exec bash

