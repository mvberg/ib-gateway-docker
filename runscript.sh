#!/bin/bash

socat TCP-LISTEN:4003,fork TCP:0.0.0.0:4001&
# Tail latest in log dir
(sleep 30 && ( tail -f $(find $LOG_PATH -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-) ) ) &
xvfb-daemon-run /opt/IBController/Scripts/DisplayBannerAndLaunch.sh
