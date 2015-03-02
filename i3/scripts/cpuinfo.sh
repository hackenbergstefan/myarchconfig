export LC_NUMERIC=C LC_COLLATE=C

cpunum=$(nproc)

#get usage in percent per cpu
usage=$(top -b -n 3 -d 0.2 | grep -e '%CPU[0-9]' | tail -n $cpunum | awk '{print $4}' | sed -rn 's/^([0-9]+).*/\1/p' | tr "\\n" " ")
# get process with maximum cpu usage
process=$(ps -eo %cpu,comm | sort -k1 -n -r | head -1 | awk '{print $2}')

echo "$usage ($process)"
