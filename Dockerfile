FROM ubuntu:22.04

# Set timezone to America/Chicago
ENV TZ=America/Chicago

LABEL maintainer="forhire"

ARG IB_GATEWAY_VERSION=stable-standalone
ARG IB_CONTROLLER_VERSION=3.16.0
ARG IB_GATEWAY_INSTVER=stable-standalone

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget unzip xvfb libxtst6 libxrender1 libxi6 x11vnc socat software-properties-common iproute2 ncat && \
    rm -rf /var/lib/apt/lists/*

# Setup IB TWS and IBController
RUN mkdir -p /opt/TWS && \
    cd /opt/TWS && \
    wget https://download2.interactivebrokers.com/installers/ibgateway/${IB_GATEWAY_VERSION}/ibgateway-${IB_GATEWAY_VERSION}-linux-x64.sh && \
    chmod a+x ibgateway-${IB_GATEWAY_VERSION}-linux-x64.sh && \
    mkdir -p /opt/IBController/Logs && \
    cd / && \
    printf "/root/Jts/ibgateway/${IB_GATEWAY_INSTVER}\n\n" | /opt/TWS/ibgateway-${IB_GATEWAY_VERSION}-linux-x64.sh && \
    rm /opt/TWS/ibgateway-${IB_GATEWAY_VERSION}-linux-x64.sh && \
    cd /opt/IBController/ && \
    wget -q https://github.com/IbcAlpha/IBC/releases/download/${IB_CONTROLLER_VERSION}/IBCLinux-${IB_CONTROLLER_VERSION}.zip && \
    unzip ./IBCLinux-${IB_CONTROLLER_VERSION}.zip && \
    chmod -R u+x *.sh && \
    chmod -R u+x scripts/*.sh && \
    rm IBCLinux-${IB_CONTROLLER_VERSION}.zip

WORKDIR /

# Set display environment variable
ENV DISPLAY :0

COPY runscript.sh /
COPY vnc/xvfb_init /etc/init.d/xvfb
COPY vnc/vnc_init /etc/init.d/vnc
COPY vnc/xvfb-daemon-run /usr/bin/xvfb-daemon-run

USER root

RUN chmod -R u+x /runscript.sh && \
    chmod -R 755 /usr/bin/xvfb-daemon-run && \
    chmod 755 /etc/init.d/xvfb && \
    chmod 755 /etc/init.d/vnc

#USER nobody

# Below files copied during build to enable operation without volume mount
COPY ib/IBController.ini /opt/IBController/IBController.ini

# Set environment variables
ENV VNC_PASSWORD=1234
ENV TWS_MAJOR_VRSN=${IB_GATEWAY_INSTVER}
ENV IBC_INI=/opt/IBController/IBController.ini
ENV IBC_PATH=/opt/IBController
ENV TWS_PATH=/root/Jts
ENV TWS_CONFIG_PATH=/root/Jts
ENV SOCAT_LISTEN_PORT=5003
ENV SOCAT_DEST_PORT=4003
ENV SOCAT_DEST_ADDR=127.0.0.1

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD nc -z localhost 4003 || exit 1

# Expose VNC port
EXPOSE 5902:5900

# Expose IB Gateway API port
EXPOSE 4003

# Expose IB Gateway API port
EXPOSE 5003

CMD /bin/bash runscript.sh

