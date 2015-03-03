#!/bin/sh
if xrandr -q | grep -q 'HDMI1 connected'; then
  xset -dpms
  xset s noblank
  xset s off
  xrandr --output HDMI1 --auto --right-of eDP1 --output eDP1 --auto
  asoundconf set-default-card MID
elif xrandr -q | grep -q 'DP2 connected'; then
  xset -dpms
  xset s noblank
  xset s off
  xrandr --output DP2 --auto --right-of eDP1 --output eDP1 --auto
  asoundconf set-default-card MID
else
  xset +dpms
  xset s blank
  xset s on
  xrandr --output DP2 --off --output HDMI1 --off --output eDP1 --auto
  asoundconf set-default-card PCH
fi
