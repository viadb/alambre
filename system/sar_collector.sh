#!/bin/bash

# Sar to be processed in ksar

DT=$(ls /var/log/sa/sa[0-9][0-9] | tr '\n' ' ' | sed 's/\/var\/log\/sa\/sa/ /g') 
 > /tmp/sar-$(hostname)-multiple.txt for i in $DT; do 
  LC_ALL=C sar -A -f /var/log/sa/sa$i >> /tmp/sar-$(hostname)-multiple.txt 
done

