#!/bin/bash

#TODO: iwconfig shouldnt be called double
essid=`iwconfig wlp3s0 | awk -F '"' '/ESSID/ {print $2}'`
stngth=`iwconfig wlp3s0 | awk -F '=' '/Quality/ {print $2}' | cut -d '/' -f 1`

case `expr $stngth / 10` in
  0)  bar='[---------]' ;;
  1)  bar='[<fc=#db2828>#</fc>--------] ' ;;
  2)  bar='[<fc=#db2828>#</fc>--------] ' ;;
  3)  bar='[<fc=#db2828>##</fc>-------] ' ;;
  4)  bar='[<fc=#db2828>###</fc>------] ' ;;
  5)  bar='[<fc=#db2828>####</fc>-----] ' ;;
  6)  bar='[<fc=#db2828>#####</fc>----] ' ;;
  7)  bar='[<fc=#db2828>######</fc>---] ' ;;
  8)  bar='[<fc=#db2828>#######</fc>--] ' ;;
  9)  bar='[<fc=#db2828>########</fc>-] ' ;;
  10) bar='[<fc=#db2828>#########</fc>] ' ;;
  *)  bar='[<fc=#db2828>!</fc>] ' ;;
esac
echo -n $essid $bar

# Mail
mails=`find ~/Mail/stefan/*/new -type f | wc -l`
if ! [[ $mails == "0" ]]; then
  echo -n "  |  <fc=#00ff7e>Mails: $mails</fc>"
fi

#DropboxON=$(ps -A | grep -c dropbox)
#if ! [[ $DropboxON == "0" ]]; then
  #echo -n "| DrpB: $DropboxON "
#fi

#VirtualBoxON=$(ps -A | grep -c VirtualBox)
#if ! [[ $VirtualBoxON == "0" ]]; then
  #echo -n "| VBox: $VirtualBoxON "
#fi

echo -n " "

echo -n $(amixer get Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print " | muted" } else { print " | Vol: " $2/10 }}' | head -n 1)

#others:
#printDiskInfo
  #RFSP=$(df -h / | tail -1 | awk '{ print $5 }' | tr -d '%')
  #HFSP=$(df -h /home | tail -1 | awk '{ print $5 }' | tr -d '%')

#printBrightnessInfo()
  #BRIFILE=$(cat /sys/class/backlight/acpi_video0/actual_brightness)
  #Bri=$(expr $BRIFILE \* 15)

#anzahl Prozesse:
#echo -n " "
#echo -n "Procs: " 
 #ps -ef | wc -l

echo " "
