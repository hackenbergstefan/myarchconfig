#!/bin/sh

stngth=`iwconfig wlp3s0 | awk -F '=' '/Quality/ {print $2}' | cut -d '/' -f 1`


if [[ $stngth == "" ]]; then
    echo "down"
else
    echo "$stngth%"
fi
