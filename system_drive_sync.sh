#!/bin/sh
if grep -qs '/backup' /proc/mounts; then
    logger  "/Backup partition is mounted. Sync  is starting"
else
    logger -s "Something went wrong with the mount...Aborting backup"
    exit
fi
rsync --bwlimit=10000 --delete --log-file="/tmp/rsync.log"  --exclude="/dev/*" --exclude="/backup/*" --exclude="/sys/*" --exclude="/tmp/*" --exclude="/run/*" --exclude="/mnt/*" --exclude="/media/*" --exclude="/var/log/*"--exclude="/lost+found" --exclude="/backup/*" --exclude="/var/log/*" --exclude="/proc/*" -aAXHv   / /backup 

