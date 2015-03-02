#!/bin/sh
LC_NUMERIC=C LC_COLLATE=C


cur_brightness=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)

echo $(printf "%.0f" $(echo "scale=2; $cur_brightness / $max_brightness * 100" | bc))
