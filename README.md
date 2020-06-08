# Unifi Controller Docker Container

This is a fork of brijohn's unifi-controller.  It has been modified to draw UniFi from the vendor-provided apt source.

## Update Policy

The image is updated on the following policy:

* Weekly, Sundays at 00:00: The `master` branch will be re-built and tagged `latest`.  This allows for upstream packages to be updated.  It will always use the latest version of UniFi.
* On UniFi update: When I notice there's a new UniFi release, I'll push a new tag to the git repo; and this will create a new docker tag and update `latest`.
* Ad-hoc: As and when I make changes, I'll push to dev.  It might work but it also might break.

For stability, choose latest.  For a specific UniFi revision, choose the tag.  For random funbags, choose dev.


## Image Installation

From Docker Hub:

```sh
docker pull lumel/unifi-controller
```
From Source:

```sh
git clone https://github.com/HenryJS/docker-unifi-controller.git
cd docker-unifi-controller
docker build -t "unifi-controller:latest" --rm .
```


## Running the Container

Create a volume to store the unifi persistence data, then next launch the container using the previously created volumes.

```sh
docker volume create --name unifi
docker run -d -p 8080:8080 \
              -p 8443:8443 \
			  -p 3478:3478/udp \
			  -p 10001:10001/udp
			  -v unifi:/usr/lib/unifi/data \
			  --name unifi \
			  lumel/unifi-controller
```

If you'd rather maintain state in a specific place in the local filesystem, do this instead:

```sh
mkdir -p /wherever/unifi-controller
docker run -d -p 8080:8080 \
              -p 8443:8443 \
			  -p 3478:3478/udp \
			  -p 10001:10001/udp
			  -v /wherever/unifi-controller:/usr/lib/unifi/data \
			  --name unifi \
			  lumel/unifi-controller
```


## Authors
- Henry Southgate - [Github](https://github.com/HenryJS/)
- Brian Johnson - [Github](https://github.com/brijohn/) - brijohn@gmail.com

Distributed under the GPL 3 license. See ``LICENSE`` for more information.
