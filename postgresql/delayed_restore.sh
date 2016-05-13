#!/bin/bash
# Provide a simple way to implement  delayed server using restore command

# NOTES:
# -d (delay option) is in hours.

#Mandatory parameters:
# archive directory, XLOG DIR, DELAY hours

# Example line in teh recovery.conf
#restore_command='delayed_restore.sh -D /mnt/server/achivedir -x %p'   

# need to check if full path in the -x optoin needed

# I recommend to use pg_archivecleanup for clean up the log files instead this file.

# archive_cleanup_command = 'find /media/wal_archive/wals -type f -and -name "*.gz.done" -and -not -path "*/archive_status/*" -and -not -newer "/media/wal_archive/wals/%r.gz" -and -not -name "%r.gz.done" -maxdepth 1 -delete'

TMPDIR=/tmp
#_T_=$(basename ${0})
FLAGFILE=$TMPDIR/$(basename $0).flag
TIMEFILE=$TMPDIR/time_checkpoint
DEFHOURS=24
DELAY=$DEFHOURS
RECOVERY_DIR=/var/local/dbarchive

# restore_command
#
# specifies the shell command that is executed to copy log files
# back from archival storage.  The command string may contain %f,
# which is replaced by the name of the desired log file, and %p,
# which is replaced by the absolute path to copy the log file to.
#
# This parameter is *required* for an archive recovery, but optional
# for streaming replication.
#
# It is important that the command return nonzero exit status on failure.
# The command *will* be asked for log files that are not present in the
# archive; it must return nonzero when so asked.
#
# NOTE that the basename of %p will be different from %f; do not
# expect them to be interchangeable.
#
#restore_command = ''           # e.g. 'cp /mnt/server/archivedir/%f %p'

# TODO: Add option by left percentage:
# [root@ip-10-5-167-133 ~]# df /dev/md10 | tail -n1 | awk '{ CALC=($3 * 100 /$2) ; print CALC}'
#0.0800013
#
#  - Add uncompress option
#  - Add option to avoid .done mark (when you have more than 1 instance recovering)

usage(){
	echo "Usage: $0 -D /var/local/dbarchive/%f -x %p -d 24"
	echo "       -d 24 is the amount of delayed hours"
	echo " restore_command = '$0  -D /var/local/dbarchive/%f -x %p -d 24'"
	exit 1
}
 

while getopts 'D:d:x:S:h' OPTION 
do
  case $OPTION in
    D)
      RECFILE=$OPTARG
      ;;
    x)
      XLOGDIR=$OPTARG
      ;;
    d)
      DELAY=$OPTARG
      ;;
    S)
      SPACE_TS=$OPTARG
      ;;
    h)
      usage
      ;;
    u)
      NOTCOMPRESS=1
      ;;
    *)
      exit 1
      ;;
  esac
done

if [ -z DELAY -o SPACE_TS ] ; then
  echo "You need at least -S or -d option set"
  exit 10
fi

#
# This block is for delay with percentage threshold.
#
if [ ! -z SPACE_TS ] ; then
  DIRNAME=$(dirname RECFILE)
  OCC_PERC=$(df DIRNAME | tail -n1 | awk '{ CALC=($3 * 100 /$2) ; print CALC}' )
  if [ $OCC_PERC -gt $SPACE_TS  -a  "$NOTCOMPRESS" != "1" ] ; then
    gunzip -c "${RECFILE}.gz" > "$XLOGDIR" || { echo "Some error ocurred while copying. $?" ; exit 20 ;  } && mv "${RECFILE}.gz" "${RECFILE}.gz.done"
  fi
  if [ $OCC_PERC -gt $SPACE_TS  -a  "$NOTCOMPRESS" == "1" ] ; then
    cp "${RECFILE}.gz" $XLOGDIR || { echo "Some error ocurred while copying. $?" ; exit 30 ;  } 
  fi 
fi

_DATE_=$(date -d "$DELAY hours ago")
touch -d "$_DATE_" $TIMEFILE || { echo "Check permissions on the $TMPDIR folder" ; exit 5 ; }

#find $RECDIR -mtime $DELAYh -exec cp {} $XLOGDIR \;    ||  { echo "An error ocurred: $?" ; exit 3 ;  }



#
# If the server goes down during recovery, it'll ask for old segments.
# That's why we recheck those were in .done state
#
if [ -f "${RECFILE}.gz.done" ] ; then
  # force-restore, no delay, or archive cleanup will mess up
  rm -f "$TIMEFILE"
  gunzip -c "${RECFILE}.gz.done" > "$XLOGDIR" || { echo "Some error ocurred while copying. $?" ; exit 10 ;  }
else
  if [ "${RECFILE}.gz" -ot "$TIMEFILE" ]
  then
    rm -f "$TIMEFILE"
    gunzip -c "${RECFILE}.gz" > "$XLOGDIR" || { echo "Some error ocurred while copying. $?" ; exit 10 ;  } && mv "${RECFILE}.gz" "${RECFILE}.gz.done"
  fi
fi

exit 0
