#!/bin/bash

xvfb-daemon-run /opt/IBController/scripts/displaybannerandlaunch.sh &
# Tail latest in log dir
sleep 1
tail -f $(find $LOG_PATH -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-) &

# Give enough time for a connection before trying to expose on 0.0.0.0:4003
while ! ss -ltn | grep 4001; do
   sleep 1
done

echo "Forking :::4001 onto 0.0.0.0:4003\n"
#socat TCP-LISTEN:4003,fork TCP:127.0.0.1:4001

socat -d -d -d  TCP-LISTEN:4003,fork,forever,reuseaddr,keepalive,keepidle=10,keepintvl=10,keepcnt=2 TCP:127.0.0.1:4001

