FROM ubuntu:20.04

LABEL maintainer="forhire"

RUN  apt-get update \
  && apt-get install -y wget unzip xvfb libxtst6 libxrender1 libxi6 x11vnc socat software-properties-common iproute2 && apt-get clean && apt-get autoclean

# Setup IB TWS and IBController
RUN mkdir -p /opt/TWS \
 && cd /opt/TWS \
 && wget https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh \
 && chmod a+x ibgateway-stable-standalone-linux-x64.sh \
 && mkdir -p /opt/IBController/ \
 && mkdir -p /opt/IBController/Logs \
 && cd / \
 && yes n | /opt/TWS/ibgateway-stable-standalone-linux-x64.sh \
 && rm /opt/TWS/ibgateway-stable-standalone-linux-x64.sh \
 && cd /opt/IBController/ \
 && wget -q https://github.com/IbcAlpha/IBC/releases/download/3.8.5/IBCLinux-3.8.5.zip \
 && unzip ./IBCLinux-3.8.5.zip \
 && chmod -R u+x *.sh \
 && chmod -R u+x scripts/*.sh \
 && rm IBCLinux-3.8.5.zip

WORKDIR /

ENV DISPLAY :0

ADD runscript.sh runscript.sh
ADD ./vnc/xvfb_init /etc/init.d/xvfb
ADD ./vnc/vnc_init /etc/init.d/vnc
ADD ./vnc/xvfb-daemon-run /usr/bin/xvfb-daemon-run

RUN chmod -R u+x runscript.sh \
  && chmod -R 777 /usr/bin/xvfb-daemon-run \
  && chmod 777 /etc/init.d/xvfb \
  && chmod 777 /etc/init.d/vnc

# Below files copied during build to enable operation without volume mount
COPY ./ib/IBController.ini /root/IBController/IBController.ini

CMD bash runscript.sh
