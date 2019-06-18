FROM raspbian/stretch
MAINTAINER Josef Eisl <zapster@zapster.cc>

# install runtime dependencies
RUN apt-get update &&\
  apt-get install -y libcap-dev net-tools wget unzip &&\
  rm -rf /var/lib/apt/lists/*

# install omada controller (instructions taken from install.sh); then create a user & group and set the appropriate file system permissions
RUN cd /tmp &&\
  wget https://static.tp-link.com/2019/201903/20190326/Omada_Controller_v3.1.4_linux_x64.tar.gz.zip &&\
  unzip Omada_Controller_v3.1.4_linux_x64.tar.gz.zip &&\
  rm Omada_Controller_v3.1.4_linux_x64.tar.gz.zip &&\
  tar zxvf Omada_Controller_v3.1.4_linux_x64.tar.gz &&\
  rm Omada_Controller_v3.1.4_linux_x64.tar.gz &&\
  cd Omada_Controller_* &&\
  mkdir /opt/tplink/EAPController -vp &&\
  cp bin /opt/tplink/EAPController -r &&\
  cp data /opt/tplink/EAPController -r &&\
  cp properties /opt/tplink/EAPController -r &&\
  cp webapps /opt/tplink/EAPController -r &&\
  cp keystore /opt/tplink/EAPController -r &&\
  cp lib /opt/tplink/EAPController -r &&\
  cp install.sh /opt/tplink/EAPController -r &&\
  cp uninstall.sh /opt/tplink/EAPController -r &&\
  cp jre /opt/tplink/EAPController/jre -r &&\
  chmod 755 /opt/tplink/EAPController/bin/* &&\
  chmod 755 /opt/tplink/EAPController/jre/bin/* &&\
  cd /tmp &&\
  rm -rf /tmp/Omada_Controller* &&\
  groupadd -g 508 omada &&\
  useradd -u 508 -g 508 -d /opt/tplink/EAPController omada &&\
  mkdir /opt/tplink/EAPController/logs /opt/tplink/EAPController/work &&\
  chown -R omada:omada /opt/tplink/EAPController/data /opt/tplink/EAPController/logs /opt/tplink/EAPController/work

RUN mkdir -p /data/db && chown omada:omada /data/db &&\
  mkdir -p /etc/my_init.d

RUN apt-get update &&\
  apt-get install -y jsvc mongodb &&\
  rm -rf /var/lib/apt/lists/*

RUN rm -rf /opt/tplink/EAPController/bin/mongod &&\
  ln -s /usr/bin/mongod /opt/tplink/EAPController/bin/mongod

ADD ./15_run-omada-controller.sh /opt/tplink/EAPController/start.sh

USER omada
WORKDIR /opt/tplink/EAPController
EXPOSE 8088 8043
VOLUME ["/opt/tplink/EAPController/data","/opt/tplink/EAPController/work","/opt/tplink/EAPController/logs"]
CMD ["/bin/bash", "-c", "/opt/tplink/EAPController/start.sh"]
