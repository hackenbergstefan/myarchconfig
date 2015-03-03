#!/bin/sh
/usr/bin/offlineimap -o -u ttyui
echo "**** Offlineimap is ready (at $(date)) ****"
python /home/stefan/bin/mymailbox_orderer.py
