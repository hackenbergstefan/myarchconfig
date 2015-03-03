#!/bin/sh
# prints information about the current battery state
# in JSON format for i3status
LC_NUMERIC=C LC_COLLATE=C

PATH_TO_BATS="/sys/class/power_supply/BAT*"
COLOR="#ffffff"
COLOR_ALARM="#dd0000"
COLOR_LOAD="#00ee00"

bat_count=$(acpi -b | wc -l)
ac_present=$(acpi -a | grep -c on-line)

energy_now=$(cat $PATH_TO_BATS/energy_now | awk '{s+=$1} END {print s}')
energy_full=$(cat $PATH_TO_BATS/energy_full | awk '{s+=$1} END {print s}')
percent=$(printf "%.0f" $(echo "scale=4; ${energy_now}/${energy_full}*100" | bc))
power_now=$(cat $PATH_TO_BATS/power_now | awk '{s+=$1} END {print s}')
sec_remain=$(echo "$energy_now*3600/$power_now" | bc)


if [[ $bat_count == "0" ]]; then
  echo -n "noBat"
else
  if [[ $ac_present == "0" ]]; then
    time_formatted=$(date -u -d @$sec_remain +"%H:%M")
    watts_formatted="$(printf "%.1f" $(echo "scale=2; $power_now/10^6" | bc))"
    color=$COLOR
    if [ $sec_remain -lt 300 ]; then 
        color=$COLOR_ALARM
    fi
    echo "$percent% ${time_formatted}h (-${watts_formatted}W)"
    echo
    echo "$color"
  else
    watts_formatted="+$(printf "%.1f" $(echo "scale=2; $power_now/10^6" | bc))W"
    color=$COLOR_LOAD
    if [[ $power_now == "0" ]]; then
        echo "$percent%"
    else
        echo "$percent% ($watts_formatted)"
    fi
    echo
    echo "$color"
  fi
fi
