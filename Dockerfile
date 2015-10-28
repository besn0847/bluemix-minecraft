FROM itzg/ubuntu-openjdk-7

MAINTAINER itzg

ENV APT_GET_UPDATE 2015-10-03
RUN DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
        && apt-get install -y --force-yes --no-install-recommends \
		supervisor openssh-server pwgen sudo vim-tiny net-tools \
               libmozjs-24-bin imagemagick \
        && apt-get autoclean \
        && apt-get autoremove \
        && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/js js /usr/bin/js24 100

ADD run.sh /
ADD sshd.conf /etc/supervisor/conf.d/
ADD minecraft.conf /etc/supervisor/conf.d/

RUN wget -O /usr/bin/jsawk https://github.com/micha/jsawk/raw/master/jsawk
RUN chmod +x /usr/bin/jsawk
RUN useradd -M -s /bin/false --uid 1000 minecraft \
  && mkdir /data \
  && mkdir /data/world \
  && mkdir /data/logs \
  && chown minecraft:minecraft /data

RUN mkdir -p /var/run/sshd &&\
        sed -i -e 's/PermitRootLogin without-password/PermitRootLogin no/g' /etc/ssh/sshd_config &&\
        sed -i -e 's/^session    required     pam_loginuid.so$/session    optional     pam_loginuid.so/g' /etc/pam.d/sshd &&\
        useradd -d /home/default -m default &&\
        mkdir -p /home/default/Documents &&\
        echo 'default:passw0rd' | chpasswd &&\
        echo "default ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/default &&\
        chmod 0440 /etc/sudoers.d/default

COPY start.sh /start
COPY start-minecraft.sh /start-minecraft
RUN chmod +x /start /start-minecraft /run.sh

COPY server.properties /data/
COPY banned-ips.json /data/
COPY banned-players.json /data/
COPY eula.txt /data/
COPY ops.json /data/
COPY usercache.json /data/
COPY whitelist.json /data/

# Special marker ENV used by MCCY management tool
ENV MC_IMAGE=YES

ENV UID=1000
ENV MOTD A Minecraft Server Powered by Docker
ENV JVM_OPTS -Xmx128M -Xms128M
ENV TYPE=VANILLA VERSION=LATEST FORGEVERSION=RECOMMENDED LEVEL=world PVP=true DIFFICULTY=easy \
  LEVEL_TYPE=DEFAULT GENERATOR_SETTINGS=

EXPOSE 9080 22

WORKDIR /data

CMD ["/run.sh"]

