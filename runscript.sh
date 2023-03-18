#!/bin/bash

socat -d -d -d  TCP-LISTEN:${SOCAT_LISTEN_PORT},fork,forever,reuseaddr,keepalive,keepidle=10,keepintvl=10,keepcnt=2 TCP:${SOCAT_DEST_ADDR}:${SOCAT_DEST_PORT} &

#xvfb-daemon-run /opt/IBController/scripts/displaybannerandlaunch.sh 


# Create VNC password file
mkdir -p ~/.vnc
echo "${VNC_PASSWORD}" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd


# Set VNC resolution
echo "geometry=${RESOLUTION}" > ~/.vnc/config


counter=0

# Start the VNC server
vncserver $DISPLAY -depth 24

while [ $counter -lt 5 ]; do
    if xdpyinfo >/dev/null 2>&1; then
        echo "XWindows display is available"
        break
    else
        echo "XWindows display is not available, trying again in 5 seconds..."
        counter=$((counter+1))
	vncserver $DISPLAY -depth 24 
        sleep 5
    fi
done

if [ $counter -eq 5 ]; then
    echo "XWindows display is not available after 5 attempts, exiting..."
    exit 1
fi

# Start an x11vnc server for remote access
#x11vnc -display $DISPLAY -passwdfile ~/.vnc/passwd -forever -shared -repeat -noxdamage -noxfixes -bg

/opt/IBController/scripts/displaybannerandlaunch.sh 

ps -ef | cat
cat /Logs/ibc*.txt /opt/IBController/Logs/ibc*.txt

