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

echo -e "\e[94mChecking UPS:\e[0m"
echo  -e "\e[94mSTATUS: \e[0m"
sudo upsc apc-700@localhost  2>&1 | grep ups.status
echo  -e "\e[94mSELFTEST: \e[0m"
sudo upsc apc-700@localhost  2>&1 | grep ups.test.result
echo  -e "\e[94mSupply Voltage: \e[0m"
sudo upsc apc-700@localhost  2>&1 | grep input.voltage
echo -e "\e[94mLoad: \e[0m"
sudo upsc apc-700@localhost  2>&1 | grep ups.load
echo  -e "\e[94mBattery Charge: \e[0m"
sudo upsc apc-700@localhost  2>&1 | grep battery.charge
echo  -e "\e[94mAvailable time with current load: \e[0m"
sudo upsc apc-700@localhost  2>&1 | grep battery.runtime
echo  -e "\e[94mBattery Voltage: \e[0m"
sudo upsc apc-700@localhost  2>&1 | grep battery.voltage



echo -e "\e[94mChecking Disk Status:\e[0m"
for DEV in /sys/block/sd*
do
 DEV=`basename $DEV`
 sudo sdparm -i /dev/$DEV | grep -i $DEV
 out=$(sudo /usr/sbin/smartctl -H /dev/sda -d sat)
 searchString="PASSED"
 if `echo ${out} | grep "${searchString}" 1>/dev/null 2>&1`
 then
  echo -e "Status \e[32mOk\e[0m"
 else
 echo -e "Default \e[31mRedDrive has S.M.A.R.T. errors!\e[0"
 fi
 sudo hdparm -C /dev/$DEV
done
echo -e "\e[94mRaid1 Array Status:\e[0m"
sudo mdadm --detail /dev/md0  | grep -i State
echo -e "\e[94mDocker Status:\e[0m"
sudo docker stats --no-stream --all
exit 0
