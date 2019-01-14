#!/bin/bash
cd /opt/n64
modprobe gamecon_gpio_rpi map=6,6,6,6
./create_joysticks.sh
sleep 5
screen -dmS n64_1 python ./joy1.py
screen -dmS n64_2 python ./joy2.py
screen -dmS n64_3 python ./joy3.py
screen -dmS n64_4 python ./joy4.py
