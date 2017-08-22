#!/bin/bash

# Sar to be processed in ksar
# Some systems have /var/log/sysstat/

# For RHEL variants
DT=$(ls /var/log/sa/sa[0-9][0-9]) 
for i in $DT; do 
  LC_ALL=C sar -A -f $i
done | gzip -c  > /tmp/sar-$(hostname)-multiple.txt.gz

# For debian/ubuntu
DT=$(ls /var/log/sysstat/sa[0-9][0-9]) 
for i in $DT; do 
  LC_ALL=C sar -A -f $i  ##  >> /tmp/sar-$(hostname)-multiple.txt 
done | gzip -c  > /tmp/sar-$(hostname)-multiple.txt.gz

# Some shell can need parsing ls output (check previous commits) 
