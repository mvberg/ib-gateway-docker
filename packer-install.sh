export TZ=America/Chicago

#COPY ./ib/IBController.ini /root/IBController/IBController.ini
#COPY ./ib/jts.ini /root/Jts/jts.ini

#export DISPLAY=:0
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y tzdata 

#apt-get install --no-install-recommends -y xubuntu-core^
apt-get install --no-install-recommends -y  wget unzip xvfb socat ca-certificates x11vnc
#libxtst6 libxrender1 libxi6 x11vnc socat 
  #&& apt-get install -y software-properties-common \

# Setup IB TWS
mkdir -p /opt/TWS
cd /opt/TWS
wget https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh
chmod a+x ibgateway-stable-standalone-linux-x64.sh

# Setup  IBController
mkdir -p /opt/IBController/ && mkdir -p /opt/IBController/Logs
cd /opt/IBController/
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

#echo "Showing root home contents" ; find /root

mkdir -p /root/IBController && cp /tmp/ib/IBController.ini /root/IBController/IBController.ini
mkdir -p /root/jts && cp /tmp/ib/jts.ini /root/Jts/jts.ini

rm -fR /tmp/*

apt-get remove --purge -y distro-info-data dmsetup file gir1.2-glib-2.0 gir1.2-packagekitglib-1.0 glib-networking-common glib-networking-services gnupg-l10n gnupg-utils gpg gpg-agent gpg-wks-server gpgconf gpgsm iso-codes krb5-locales libapparmor1 libargon2-1 libasn1-8-heimdal libassuan0 libbrotli1 libcap2 libcap2-bin libcryptsetup12 libdconf1 libdevmapper1.02.1 libgirepository-1.0-1 libglib2.0-0 libglib2.0-bin libglib2.0-data libgssapi-krb5-2 libgssapi3-heimdal libgstreamer1.0-0 libhcrypto4-heimdal libheimbase1-heimdal libheimntlm0-heimdal libhx509-5-heimdal libicu66 libip4tc2 libjson-c4 libk5crypto3 libkeyutils1 libkmod2 libkrb5-26-heimdal libkrb5-3 libkrb5support0 libksba8 libldap-2.4-2 libldap-common liblmdb0 libmagic-mgc libmagic1 libmpdec2 libnpth0 libpackagekit-glib2-18 libpam-cap libpolkit-agent-1-0 libpolkit-gobject-1-0 libproxy1v5 libpython3-stdlib libpython3.8-minimal libpython3.8-stdlib libreadline8 libroken18-heimdal libsqlite3-0 libstemmer0d libwind0-heimdal libxml2 libyaml-0-2 lsb-release mime-support pinentry-curses python-apt-common python3 python3-apt python3-certifi python3-chardet python3-dbus python3-distro-info python3-gi python3-idna python3-minimal python3-pkg-resources python3-requests python3-requests-unixsocket python3-six python3-software-properties python3-urllib3 python3.8 python3.8-minimal readline-common shared-mime-info unattended-upgrades xdg-user-dirs xz-utils xfonts-base 

apt-get -y autoclean 
apt-get -y autoremove 
rm -rf /var/lib/apt/lists/* /opt/IBController/IBCLinux-3.8.4-beta.1.zip /opt/TWS/ibgateway-stable-standalone-linux-x64.sh /opt/IBController/userguide.pdf

