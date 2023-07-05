#! /bin/bash

if [ "$UID" -ne 0 ]
then
	echo -e 'Please run as root! (Please type "sudo" to start of command line)'
	exit
fi

echo -e '*********** phase 1. ethernet test ***********'
wget -q --spider http://google.com
if ! [ $? -eq 0 ]
then
	echo -e '\nPlease check internet connection!\n'
	exit
else
	echo -e '\nInternet Ready...\n'
fi
sleep 1;

echo -e '*********** phase 2. fan test ****************\nPlease Check Fan'
echo 255 > /sys/devices/pwm-fan/target_pwm
echo -e '\n'
sleep 1;

echo -e '************* phase 3. lte test **************'
result=$(ls /dev/ttyACM* 2> /dev/null)
if [ $? -eq 0 ]
then
	echo -e 'LTE Ready... '$result'\n'
else
	echo -e 'Please Check LTE device\n'
fi
sleep 1;


echo -e '*********** phase 4. serial test *************'
if ! [ -x "$(command -v cutecom)" ]
then
        echo -e 'cutecom is not installed...\n start install';
        apt-get update 2> /dev/null > /dev/null;
        apt-get install -y cutecom 2> /dev/null > /dev/null;
	echo -e 'cutecom install success';
fi

#gnome-terminal -e "bash -c \"sudo cutecom; exec bash\"" > /dev/null 2> /dev/null &
gnome-terminal -e "sudo cutecom" > /dev/null 2> /dev/null &
sleep 1;


echo -e '************ phase 5. camera test ************'
#gnome-terminal -e "bash -c \"gst-launch-1.0 v4l2src device=/dev/video0 ! ximagesink; exec bash\"" > /dev/null 2> /dev/null &
gnome-terminal -e "gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw, width=640, height=480 ! ximagesink" > /dev/null 2> /dev/null &
sleep 1;

echo -e '************ phase 6. usb-C test *************'

while true;
do
	lsusb -t > before_usb-c.txt

	echo -e ' Please Insert USB-C storage in'
	echo '10s...'
	sleep 1;
	echo '9s...'
	sleep 1;
	echo '8s...'
	sleep 1;
	echo '7s...'
	sleep 1;
	echo '6s...'
	sleep 1;
	echo '5s...'
	sleep 1;
	echo '4s...'
	sleep 1;
	echo '3s...'
	sleep 1;
	echo '2s...'
	sleep 1;
	echo '1s...'
	sleep 1;
	echo -e ' Time Up!'

	lsusb -t > after_usb-c.txt

	echo -e 'Newly Inserted Device ->'
	diff before_usb-c.txt after_usb-c.txt
	if [[ $(diff after_usb-c.txt before_usb-c.txt | grep usb-storage | grep 480M) ]]
	then
	        echo '-> USB 2.0!'
	fi

	if [[ -x $(diff after_usb-c.txt before_usb-c.txt | grep usb-storage | grep 5000M) ]]
	then
	        echo '-> USB 3.0!'
	fi

	rm after_usb-c.txt
        rm before_usb-c.txt

	read -p "Do you want to try again...[Yy/Nn]?" yn
	case $yn in
		[Yy]* ) ;;
		[Nn]* ) break;;
		* ) echo "Please type Y or y or N or n";;
	esac

done

echo "" > ~/.bash_history
