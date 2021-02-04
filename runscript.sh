#!/bin/bash

echo "Forking :::4001 onto 0.0.0.0:4003\n"
#socat TCP-LISTEN:4003,fork TCP:127.0.0.1:4001

socat -d -d -d  TCP-LISTEN:4003,fork,forever,reuseaddr,keepalive,keepidle=10,keepintvl=10,keepcnt=2 TCP:127.0.0.1:4001 &

xvfb-daemon-run /opt/IBController/scripts/displaybannerandlaunch.sh 
