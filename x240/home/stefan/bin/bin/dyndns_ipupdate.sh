#!/bin/sh
# SERVERNAME must be a valid servername on vlinux with files:
#   /var/www/servers/servers/SERVERNAME.ip
# and A record entry in 
#   /etc/bind/db.servers
SERVERNAME=$'stefan'

IP=$(curl -s ipecho.net/plain ; echo)
if [ -n $IP ] && [[ ! $IP =~ ^\ +$ ]]; then
  curl --request GET "5.45.104.211/servers/updateip.php?pass=fepeefahash&name=$SERVERNAME&ip=$IP"
fi
