#!/bin/bash
path="/var/log/"
timestamp=$(date +%Y%m%d_%H%M%S)
filename=cleanup_log_$timestamp.log
log=$path$filename
depth=3
days=10
#end of config part, don't touch below unless you know what you are doing

START_TIME=$(date +%s)

find $path -maxdepth $depth -name "*.log*"  -type f -mtime +$days -print -delete >> $log
find $path -maxdepth $depth -name "*.gz*"   -type f -mtime +$days -print -delete >> $log
find $path -maxdepth $depth -name "*.err*"  -type f -mtime +$days -print -delete >> $log

echo "Backup:: Script Start -- $(date +%Y%m%d_%H%M)" >> $log

END_TIME=$(date +%s)

ELAPSED_TIME=$(( $END_TIME - $START_TIME ))


echo "Backup :: Script End -- $(date +%Y%m%d_%H%M)" >> $log
echo "Elapsed Time ::  $(date -d 00:00:$ELAPSED_TIME +%Hh:%Mm:%Ss) "  >> $log