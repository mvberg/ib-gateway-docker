#!/bin/bash

socat -d -d -d  TCP-LISTEN:${SOCAT_LISTEN_PORT},fork,forever,reuseaddr,keepalive,keepidle=10,keepintvl=10,keepcnt=2 TCP:${SOCAT_DEST_ADDR}:${SOCAT_DEST_PORT} &

#xvfb-daemon-run /opt/IBController/scripts/displaybannerandlaunch.sh 


# Create VNC password file
mkdir -p ~/.vnc
echo "${VNC_PASSWORD}" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd


# Set VNC resolution
echo "geometry=${RESOLUTION}" > ~/.vnc/config


# Start the VNC server
vncserver $DISPLAY -depth 24 -localhost


/opt/IBController/scripts/displaybannerandlaunch.sh 


# Start an x11vnc server for remote access
x11vnc -display $DISPLAY -passwdfile ~/.vnc/passwd -forever -shared -repeat -noxdamage -noxfixes


ps -ef | cat
cat /Logs/ibc*.txt /opt/IBController/Logs/ibc*.txt

