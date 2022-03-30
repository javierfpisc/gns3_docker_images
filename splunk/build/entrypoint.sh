#!/bin/bash

[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh

[ -f /etc/iptables/rules.v4 ] && iptables-restore < /etc/iptables/rules.v4

/opt/splunk/bin/splunk start

exec bash

