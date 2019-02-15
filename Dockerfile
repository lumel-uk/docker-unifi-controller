FROM ubuntu:18.04
MAINTAINER Brian Johnson <brijohn@gmail.com>

ARG UNIFI_VERSION
ENV DEBIAN_FRONTEND noninteractive

RUN \
# Check for mandatory build arguments
    : "${UNIFI_VERSION:?Build argument needs to be set and non-empty.}"

COPY apt/ /etc/apt/
ADD "https://dl.ubnt.com/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb" /
#Install Unifi v5
RUN apt-get update -q -y &&  apt-get upgrade -y && apt-get dist-upgrade -y
RUN apt-get update -q -y &&  apt-get upgrade -y && apt-get dist-upgrade -y && \
    apt-get install -q -y ./unifi_sysvinit_all.deb mongodb-org-server && rm unifi_sysvinit_all.deb


# Wipe out auto-generated data
RUN rm -rf /usr/lib/unifi/data/*

EXPOSE 8443/tcp 8080/tcp 8843/tcp 8880/tcp 3478/udp 10001/udp

VOLUME /usr/lib/unifi/data

WORKDIR /usr/lib/unifi

ENTRYPOINT ["java", "-Xmx256M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
CMD ["start"]

