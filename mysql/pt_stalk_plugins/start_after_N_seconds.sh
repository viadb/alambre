#!/bin/bash
trg_plugin() {
    FLAG_STALK="/tmp/backup_started_timestamp"
    [[ -f $FLAG_STALK && -s $FLAG_STALK ]] && { let time_run=$(date +%s)-$(< $FLAG_STALK) ; echo $time_run ; exit ; } || { echo 0 ; exit ; } 
}

# HOWTO
# 1 place a flag with a timestamp in seconds with `date +%s`
# date +%s > /tmp/backup_started_timestamp ; <Your backup command> ; rm -f /tmp/backup_started_timestamp ;
# chmod +x start_after_N_seconds
# Example: $((3600*3 + 1800)) (3.5 hours)
# sudo ./pt-stalk --run-time=60 --sleep=60 --interval=30 --iterations=3 --cycles=1 \
#                 --function=start_after_N_seconds.sh --threshold=$((3600*3 + 1800)) 
#                 --dest=ptstalk_136088 -- --user=<user> --pass=<pass> --port=<port if not default> --socket=<socket file> &
# echo $! > .pidptstalk

