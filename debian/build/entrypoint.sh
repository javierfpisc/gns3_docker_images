#!/bin/bash

[ -f /etc/iptables/rules.v4 ] && iptables-restore < /etc/iptables/rules.v4

exec bash

