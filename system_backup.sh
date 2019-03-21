#!/bin/sh
if grep -qs '/mnt/500gb' /proc/mounts; then
    echo "Drive is mounted."
else
    echo "Google Drive not mounted. Mounting drive"
    mount /media/gdrive
    if [ $? -eq 0 ]; then
       echo "Mount success!"
    else
       echo "Something went wrong with the mount..."
    exit
    fi
fi
#all ok, try to copy the stuff

echo "Backup is starting"
echo "Deleting old backups"

rm -f /mnt/500gb/_backups/*.zip

echo "zipping etc"
filename="/mnt/500gb/_backups/etc_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y $filename  /etc/*

echo "zipping /var/bin"
filename="/mnt/500gb/_backups/var_bin_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y $filename  /var/bin/* --exclude=*Snapshots*

echo "zipping /usr/local/bin"
filename="/mnt/500gb/_backups/usr_local_bin_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y $filename  /usr/local/bin/*

echo "zipping /var/etc"
filename="/mnt/500gb/_backups/var_etc_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y $filename  /var/etc/*



if [ -f /tmp/mysqldb.sql ];
then
   rm /tmp/mysqldb.sql
else
   echo "Old mydql db backup does not exists"
fi
mysqldump -uroot -ppassword --all-databases --skip-lock-tables > /tmp/mysqldb.sql
echo "zipping mysql database"
filename="/mnt/500gb/_backups/mysqldb_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y $filename  /tmp/mysqldb.sql
if [ -f /tmp/mysqldb.sql ];
then
   rm /tmp/mysqldb.sql
else
   echo "Old mydql db backup does not exists"
fi

echo "zipping systemd"
filename="/mnt/500gb/_backups/systemd_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y $filename  /var/lib/systemd/*


echo "zipping webpages"
filename="/mnt/500gb/_backups/www_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y $filename  /var/www/Webpages/*


echo "zipping email"
filename="/mnt/500gb/_backups/email_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y $filename  /var/mail/*

echo "zipping tor"
filename="/mnt/500gb/_backups/tor_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y $filename  /var/lib/tor/*

echo "zipping mediatomb"
filename="/mnt/500gb/_backups/mediatomb_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y $filename  /var/lib/mediatomb/*


echo "Zipping Virtualbox Config"
filename="/mnt/500gb/_backups/Vbox_Config_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y $filename  /root/.VirtualBox/*.xml 

echo "Copy virutalbox hard drive"
systemctl stop winserver
filename="/mnt/500gb/_backups/Vbox_Winserver_hdd_"`date +"%d-%m-%Y"`".zip"
zip -r -y  $filename  /root/VirtualBox\ VMs/Winserver/hdd/*.vdi*

echo "Zipping Winserver Config"
filename="/mnt/500gb/_backups/Vbox_Winserver_Config_backup_"`date +"%d-%m-%Y"`".zip"
zip -r -y -0 $filename  /root/VirtualBox\ VMs/Winserver/*.vbox*


echo "Copy ebooks"
rsync -av -e  /mnt/500gb/_ebooks\ \&\ audiobooks/text\ books/ /mnt/WD/

echo "Copy Nyakok"
rsync -av -e  cd /mnt/500gb/_Nyakok/ /mnt/WD/_Nyakok

echo "Copy Picture"
rsync -av -e  --bwlimit=10000  /mnt/500gb/Picture/ /mnt/WD/Picture

echo "Copy Pictures"
rsync -av -e --bwlimit=10000 cd /mnt/500gb/Pictures/ /mnt/WD/Pictures

echo "All done"