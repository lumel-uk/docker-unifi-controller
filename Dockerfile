FROM ubuntu:18.04
MAINTAINER Brian Johnson <brijohn@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get install -q -y gpg

#Install Unifi v5
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50
ADD unifi-controller.list /etc/apt/sources.list.d/unifi-controller.list
RUN apt-get update -q -y &&  apt-get upgrade -y && apt-get dist-upgrade -y && \
    apt-get install -q -y unifi mongodb-org-server


# Wipe out auto-generated data
RUN rm -rf /usr/lib/unifi/data/*

EXPOSE 8443/tcp 8080/tcp 8843/tcp 8880/tcp 3478/udp 10001/udp

VOLUME /usr/lib/unifi/data

WORKDIR /usr/lib/unifi

ENTRYPOINT ["java", "-Xmx256M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
CMD ["start"]

