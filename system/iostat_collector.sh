#!/bin/bash
#
# 
# Recoded from: http://www.unix.com/shell-programming-and-scripting/135941-parsing-iostat-real-time.html

lineCount=$(iostat | wc -l)
numDevices=$(expr $lineCount - 7);
interval=2
deviceFile=device_stats

iostat $interval -m -x -t |
awk -v awkDeviceFile=$deviceFile -v awkNumDevices=$numDevices '
BEGIN {
	print "date/time,device,rrqm/s,wrqm/s,r/s,w/s,rsec/s,wsec/s,avgrq-sz,avgqu-sz,await,svctm,%util" > awkDeviceFile
}
/Device:/{
  time_str=strftime("\"%Y/%m/%d %R\"")
	for (i=0; i<awkNumDevices; i++) {
		getline; $1=$1
		gsub(/ /,",",$0)
		print time_str "," $0 > awkDeviceFile
	}
}'


exit 0
