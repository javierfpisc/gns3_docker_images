#!/bin/bash

#Arrancamos sshd server
/usr/sbin/sshd -f /etc/ssh/sshd_config &

exec bash

