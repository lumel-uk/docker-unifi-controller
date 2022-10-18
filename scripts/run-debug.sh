#!/bin/bash

if [ -z $1 ]
then
	echo "Usage: $0 <test image name>" 1>&2
	exit 1
fi
imagename=$1

docker run -d \
           --net=host \
           -v /volume1/docker/unifi:/usr/lib/unifi/data \
           --name lumel-unifi-test \
		   --rm \
           $imagename

