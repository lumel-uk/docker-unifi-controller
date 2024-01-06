FROM ubuntu:20.04
LABEL author="Henry Southgate"

ENV DEBIAN_FRONTEND noninteractive

# Install core dependencies
RUN apt-get -y update && \
    apt-get -y install curl ca-certificates apt-transport-https && \
    rm -rf /var/lib/apt/lists/*	/usr/lib/unifi/data/*

# Install apt signing keys
RUN curl -o /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg && \
    curl -o /etc/apt/trusted.gpg.d/monogdb-4.2.gpg https://pgp.mongodb.com/server-4.2.pub

# Install additional sources
RUN echo 'deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse' >> /etc/apt/sources.list.d/099-monogdb.list && \
    echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' >>  /etc/apt/sources.list.d/100-ubnt-unifi.list

# Update OS and install UniFi:
# Wipe out auto-generated data
RUN \
    apt-get -y update -q && \
    apt-mark hold openjdk-11-* && \
    apt-get -y full-upgrade && \
    apt-get -y install unifi  && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    rm -rf /var/lib/apt/lists/*	/usr/lib/unifi/data/*

RUN dpkg -s unifi | grep -i version | tee /unifi-version

VOLUME /usr/lib/unifi/data

WORKDIR /usr/lib/unifi

ENTRYPOINT ["java", \
    "-Dfile.encoding=UTF-8", \
    "-Djava.awt.headless=true", \
    "-Dapple.awt.UIElement=true", \
    "-Dunifi.core.enabled=false", \
    "-Dunifi.mongodb.service.enabled=false", \
    "-Xmx1024M", \
    "-XX:+UseParallelGC", \
    "-XX:+ExitOnOutOfMemoryError", \
    "-XX:+CrashOnOutOfMemoryError", \
    "-Xlog:gc:logs/gc.log:time:filecount=2,filesize=5M", \
    "--add-opens", "java.base/java.lang=ALL-UNNAMED", \
    "--add-opens", "java.base/java.time=ALL-UNNAMED", \
    "--add-opens", "java.base/sun.security.util=ALL-UNNAMED", \
    "--add-opens", "java.base/java.io=ALL-UNNAMED", \
    "--add-opens", "java.rmi/sun.rmi.transport=ALL-UNNAMED", \
    "-jar", "/usr/lib/unifi/lib/ace.jar"]
# ENTRYPOINT ["/bin/bash"]
CMD ["start"]

