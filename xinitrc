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


(
	feh --bg-fill "/home/stefan/arch-background2.jpg"
) &


#virtualbox
/usr/bin/VBoxClient-all


exec dbus-launch xmonad

