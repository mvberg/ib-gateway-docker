#!/bin/bash

socat TCP-LISTEN:4003,fork TCP:0.0.0.0:4001&
xvfb-daemon-run /opt/IBController/Scripts/DisplayBannerAndLaunch.sh &
# Tail latest in log dir
sleep 1
tail -f $(find $LOG_PATH -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-) 

