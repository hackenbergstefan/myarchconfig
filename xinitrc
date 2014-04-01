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

exec dbus-launch xmonad

