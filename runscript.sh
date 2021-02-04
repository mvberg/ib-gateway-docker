#!/bin/bash

echo "Forking :::4001 onto 0.0.0.0:4003\n"
#socat TCP-LISTEN:4003,fork TCP:127.0.0.1:4001

socat -d -d -d  TCP-LISTEN:${SOCAT_LISTEN_PORT},fork,forever,reuseaddr,keepalive,keepidle=10,keepintvl=10,keepcnt=2 TCP:${SOCAT_DEST_ADDR}:${SOCAT_DEST_PORT} &

xvfb-daemon-run /opt/IBController/scripts/displaybannerandlaunch.sh 
