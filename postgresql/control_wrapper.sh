#!/bin/bash
# Simple postgres fresh intallation start
su postgres -c "bin/pg_ctl -D data -l logfile $1"
