FROM ubuntu:20.04
LABEL author="Henry Southgate"

ENV DEBIAN_FRONTEND noninteractive

RUN cat /etc/issue

# Install core dependencies
RUN apt-get -y update && \
    apt-get -y install curl ca-certificates apt-transport-https && \
    rm -rf /var/lib/apt/lists/*	/usr/lib/unifi/data/*

# Install apt signing keys
RUN curl -o /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg && \
    curl -o /etc/apt/trusted.gpg.d/monogdb-4.2.gpg https://pgp.mongodb.com/server-4.2.pub

# Install the MongoDB and UniFi sources
RUN echo 'deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse' >> /etc/apt/sources.list.d/099-monogdb.list && \
    echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' >>  /etc/apt/sources.list.d/100-ubnt-unifi.list

# Update OS and install UniFi:
# Wipe out auto-generated data
RUN \
    apt-get -y update -q && \
    apt-get -y full-upgrade && \
    apt-get -y install unifi  && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    rm -rf /var/lib/apt/lists/*	/usr/lib/unifi/data/*

RUN dpkg -s unifi | grep -i version | tee /unifi-version

EXPOSE 8443/tcp 8080/tcp 8843/tcp 8880/tcp 3478/udp 10001/udp

VOLUME /usr/lib/unifi/data

WORKDIR /usr/lib/unifi

ENTRYPOINT ["java", "-Xmx256M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
CMD ["start"]

