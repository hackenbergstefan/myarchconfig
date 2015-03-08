LC_NUMERIC=C LC_COLLATE=C

[[ $(printf "%.0f" $(xbacklight -get)) == "100" ]] && xbacklight -set 10% || xbacklight -set 100%
