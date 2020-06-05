FROM ubuntu:18.04
MAINTAINER Henry Southgate

ENV DEBIAN_FRONTEND noninteractive

COPY apt/ /etc/apt/

# Update OS and install Unifi v5
RUN apt-get -y update -q && \
    apt-get -y upgrade && \
	apt-get -y dist-upgrade && \
    apt-get -y install unifi 

# Wipe out auto-generated data
RUN rm -rf /usr/lib/unifi/data/*

EXPOSE 8443/tcp 8080/tcp 8843/tcp 8880/tcp 3478/udp 10001/udp

VOLUME /usr/lib/unifi/data

WORKDIR /usr/lib/unifi

ENTRYPOINT ["java", "-Xmx256M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
CMD ["start"]

