LC_NUMERIC=C LC_COLLATE=C

info=$(cat /proc/meminfo)
memfree=$(cat /proc/meminfo | grep "MemFree" | awk '{print $2}')
memfree_gb=$(printf "%.1f" $(echo "scale=4;$memfree / 10^6" | bc))
swapfree=$(cat /proc/meminfo | grep "SwapFree" | awk '{print $2}')
swapfree_gb=$(printf "%.1f" $(echo "scale=4;$swapfree/ 10^6" | bc))



case $1 in
    ram) echo "${memfree_gb}GB" ;;
    swap) echo "${swapfree_gb}GB" ;;
esac
