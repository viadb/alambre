/usr/lib/sysstat/sadc -S ALL 30 > sadcfile 

iostat -xytd 30 > iostatfile

 LC_ALL=C sar -f sadcfile -A > /home/ecalvo/ksar002
