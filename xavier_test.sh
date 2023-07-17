#! /bin/bash

if (( $EUID != 0 )); then
        echo -e "\nPlease Run as Root"\n
        exit
fi

# sudo apt-get update
# sudo apt-get install -y xdotool

echo -e "\n\nApt Update"
sudo apt-get update
echo -e "\n\n"
sleep 1

echo -e "\n\nInstall cutecom"
sudo apt-get install -y cutecom 2&> /dev/null
echo -e "\n\n"
sleep 1

echo -e "\n\nInstall nmap"
sudo apt-get install -y nmap
echo -e "\n\n"
sleep 1

function openTerminal()
{
        gnome-terminal --geometry=20x20
}

function openVideo()
{
        dev=$1
        xdotool type "gst-launch-1.0 v4l2src device=$dev ! videoscale ! \"video/x-raw, width=640, height=480\" ! xvimagesink"
}


openTerminal
sleep 1
openVideo "/dev/video0"
sleep 1
xdotool key Return
sleep 1

openTerminal
sleep 1
openVideo "/dev/video1"
sleep 1
xdotool key Return
sleep 1

openTerminal
sleep 1
openVideo "/dev/video2"
sleep 1
xdotool key Return
sleep 1

openTerminal
sleep 1
xdotool type "candump can0"
sleep 1
xdotool key Return
sleep 1

openTerminal
sleep 1
xdotool type "candump can1"
sleep 1
xdotool key Return
sleep 1

openTerminal
sleep 1
xdotool type "candump can2"
sleep 1
xdotool key Return
sleep 1

openTerminal
sleep 1
xdotool type "candump can3"
sleep 1
xdotool key Return
sleep 1

openTerminal
sleep 1
xdotool type "candump can4"
sleep 1
xdotool key Return
sleep 1

echo -e "\n\nFan Up... 255..."
echo 255 > /sys/devices/pwm-fan/target_pwm

# sleep 5s
sleep 5

echo -e "\n\nFan Down... 0..."
echo 0 > /sys/devices/pwm-fan/target_pwm
sleep 1


echo -e "\n\nEthernet eth0"
ifconfig eth0
echo -e "\n\n"
sleep 1

echo -e "\n\nEthernet eth1"
ifconfig eth1
echo -e "\n\n"
sleep 1

echo -e "\n\nEthernet eth2"
ifconfig eth2
echo -e "\n\n"
sleep 1

echo -e "\n\nPCI"\"
lspci
echo -e "\n\n"
sleep 1

echo -e "\n\nPing 10.1.1.1/24"
nmap -sn 10.1.1.1/24
echo -e "\n\n"
sleep 1

echo -e "\n\nPing 8.8.8.8"
ping 8.8.8.8 -w 5
echo -e "\n\n"
sleep 1

echo -e "\n\nCheck USB"
lsusb -t
echo -e "\n\n"
sleep 1
