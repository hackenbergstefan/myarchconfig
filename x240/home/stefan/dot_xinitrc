#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi


#set cursor
xsetroot -cursor_name left_ptr
#set keyboard layout
setxkbmap -layout de

#bind keys
xbindkeys

exec urxvtd -q -f -o &

(
  xcalib -d : 0 /home/stefan/.icc/x240.icc
	feh --bg-fill "/home/stefan/arch-background.jpg"
) &


amixer -q set Master off &
xbacklight = 50 &

([[ -f ~/bin/mailrun.sh ]] && ~/bin/mailrun.sh) &

unclutter -grab &

#exec dbus-launch /home/stefan/.cabal/bin/xmonad

#if [[ $1 == "i3" ]]; then
    exec dbus-launch --sh-syntax --exit-with-session i3
    # -V -d all > ~/.i3/i3log-$(date +'%F-%k-%M-%S') 2>&1
#elif [[ $1 == "xmonad" ]]; then
    #exec dbus-launch /home/stefan/.cabal/bin/xmonad
#else
    #echo "Choose a window manager"
#fi
