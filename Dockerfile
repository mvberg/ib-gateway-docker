FROM ubuntu:22.04

LABEL maintainer="forhire"

ARG IB_GATEWAY_VERSION=latest
ARG IB_CONTROLLER_VERSION=3.8.5

RUN apt-get update && \
    apt-get install -y wget unzip xvfb libxtst6 libxrender1 libxi6 x11vnc socat software-properties-common iproute2 && \
    rm -rf /var/lib/apt/lists/*

# Setup IB TWS and IBController
RUN mkdir -p /opt/TWS && \
    cd /opt/TWS && \
    wget https://download2.interactivebrokers.com/installers/ibgateway/${IB_GATEWAY_VERSION}/ibgateway-${IB_GATEWAY_VERSION}-linux-x64.sh && \
    chmod a+x ibgateway-${IB_GATEWAY_VERSION}-linux-x64.sh && \
    mkdir -p /opt/IBController/Logs && \
    cd / && \
    yes n | /opt/TWS/ibgateway-${IB_GATEWAY_VERSION}-linux-x64.sh && \
    rm /opt/TWS/ibgateway-${IB_GATEWAY_VERSION}-linux-x64.sh && \
    cd /opt/IBController/ && \
    wget -q https://github.com/IbcAlpha/IBC/releases/download/${IB_CONTROLLER_VERSION}/IBCLinux-${IB_CONTROLLER_VERSION}.zip && \
    unzip ./IBCLinux-${IB_CONTROLLER_VERSION}.zip && \
    chmod -R u+x *.sh && \
    chmod -R u+x scripts/*.sh && \
    rm IBCLinux-${IB_CONTROLLER_VERSION}.zip

WORKDIR /

ENV DISPLAY :0

COPY runscript.sh /
COPY vnc/xvfb_init /etc/init.d/xvfb
COPY vnc/vnc_init /etc/init.d/vnc
COPY vnc/xvfb-daemon-run /usr/bin/xvfb-daemon-run

USER root

RUN chmod -R u+x /runscript.sh && \
    chmod -R 777 /usr/bin/xvfb-daemon-run && \
    chmod 777 /etc/init.d/xvfb && \
    chmod 777 /etc/init.d/vnc

USER nobody

# Below files copied during build to enable operation without volume mount
COPY ib/IBController.ini /root/IBController/IBController.ini

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl --fail http://localhost:4001 ||

