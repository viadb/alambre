#!/bin/bash

# Sar to be processed in ksar
# Some systems have /var/log/sysstat/

# For RHEL variants
DT=$(ls /var/log/sa/sa[0-9][0-9] | tr '\n' ' ' | sed 's/\/var\/log\/sa\/sa/ /g') 
for i in $DT; do 
  LC_ALL=C sar -A -f /var/log/sa/sa$i # >> /tmp/sar-$(hostname)-multiple.txt 
done | gzip -c  > /tmp/sar-$(hostname)-multiple.txt.gz

# For debian/ubuntu
DT=$(ls /var/log/sysstat/sa[0-9][0-9] | tr '\n' ' ' | sed 's/\/var\/log\/sysstat\/sa/ /g') 
for i in $DT; do 
  LC_ALL=C sar -A -f /var/log/sysstat/sa$i # >> /tmp/sar-$(hostname)-multiple.txt 
done | gzip -c  > /tmp/sar-$(hostname)-multiple.txt.gz
