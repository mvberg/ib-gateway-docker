export TZ=America/Chicago

#COPY ./ib/IBController.ini /root/IBController/IBController.ini
#COPY ./ib/jts.ini /root/Jts/jts.ini

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata 

  apt-get install -y wget \
  && apt-get install -y unzip \
  && apt-get install -y xvfb \
  && apt-get install -y libxtst6 \
  && apt-get install -y libxrender1 \
  && apt-get install -y libxi6 \
	&& apt-get install -y x11vnc \
  && apt-get install -y socat \
  && apt-get install -y software-properties-common \

# Setup IB TWS
mkdir -p /opt/TWS
cd /opt/TWS
wget -q https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh
chmod a+x ibgateway-stable-standalone-linux-x64.sh

# Setup  IBController
mkdir -p /opt/IBController/ && mkdir -p /opt/IBController/Logs
cd /opt/IBController/
ln -s scripts Scripts
#wget -q http://cdn.quantconnect.com/interactive/IBController-QuantConnect-3.2.0.5.zip
#unzip ./IBController-QuantConnect-3.2.0.5.zip
wget https://github.com/IbcAlpha/IBC/releases/download/3.8.4-beta.1/IBCLinux-3.8.4-beta.1.zip
unzip ./IBCLinux-3.8.4-beta.1.zip
chmod -R u+x *.sh && chmod -R u+x scripts/*.sh
find /opt 

cd /

# Install TWS
yes n | /opt/TWS/ibgateway-stable-standalone-linux-x64.sh

export DISPLAY=:0

#runscript.sh runscript.sh
#./vnc/xvfb_init /etc/init.d/xvfb
#./vnc/vnc_init /etc/init.d/vnc
#./vnc/xvfb-daemon-run /usr/bin/xvfb-daemon-run

chmod -R u+x runscript.sh \
  && chmod -R 777 /usr/bin/xvfb-daemon-run \
  && chmod 777 /etc/init.d/xvfb \
  && chmod 777 /etc/init.d/vnc

echo "Showing root home contents" ; find /root

mkdir -p /root/IBController && cp /tmp/ib/IBController.ini /root/IBController/IBController.ini
mkdir -p /root/jts && cp /tmp/ib/jts.ini /root/Jts/jts.ini

#rm -fR /tmp/*

#dos2unix /usr/bin/xvfb-daemon-run \
  #&& dos2unix /etc/init.d/xvfb \
  #&& dos2unix /etc/init.d/vnc \
  #&& dos2unix runscript.sh

# Below files copied during build to enable operation without volume mount
#./ib/IBController.ini /root/IBController/IBController.ini
#./ib/jts.ini /root/Jts/jts.ini

#CMD bash runscript.sh
