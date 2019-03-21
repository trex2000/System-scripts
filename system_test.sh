#! /bin/bash

echo -e "\e[94mUpdate Status:\e[0m"
echo "$(lsb_release -d | grep -i Ubuntu)"
/usr/lib/update-notifier/update-motd-updates-available

echo -e "\e[94mSensorStatus:\e[0m"
#echo -e "\e[36mFan Speed:\e[0m"
#SENSORS=$(/usr/bin/sensors | grep -i fan)
#echo "$SENSORS"

echo -e "\e[36mTemp:\e[0m"
SENSORS=$(sudo /usr/bin/sensors | grep -i temp.:)
echo "$SENSORS"
SENSORS=$(sudo /usr/bin/sensors | grep -i Core)
echo "$SENSORS"

echo -e "\e[36mPower:\e[0m"
SENSORS=$(sudo /usr/bin/sensors | grep -i -A6 'ACPI interface')
echo "$SENSORS"

echo -e "\e[94mChecking UPS Status:\e[0m"
echo  -n "STATUS: "
apcaccess -p STATUS
echo  -n "SELFTEST: "
apcaccess -p SELFTEST
echo  -n "Supply Voltage: "
apcaccess -p LINEV
echo -n "Load: "
apcaccess -p LOADPCT
echo  -n "Battery Charge: "
apcaccess -p BCHARGE
echo  -n "Available time with current load: "
apcaccess -p TIMELEFT
echo  -n "Battery Voltage: "
apcaccess -p BATTV



echo -e "\e[94mChecking Disk Status:\e[0m"
for DEV in /sys/block/sd*
do
 DEV=`basename $DEV`
 sdparm -i /dev/$DEV | grep -i $DEV
 out=$(sudo /usr/sbin/smartctl -H /dev/sda -d sat)
 searchString="PASSED"
 if `echo ${out} | grep "${searchString}" 1>/dev/null 2>&1`
 then
  echo -e "Status \e[32mOk\e[0m"
 else
 echo -e "Default \e[31mRedDrive has S.M.A.R.T. errors!\e[0"
 fi
done
echo -e "\e[94mRaid1 Array Status:\e[0m"
sudo mdadm --detail /dev/md0  | grep -i State
exit 0
