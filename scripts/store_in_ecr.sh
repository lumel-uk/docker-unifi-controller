#!/bin/bash

set -e

IMAGE=$1
TAG=$2

if [ -z $TAG ]
then
	echo "Usage: $0 <image> <default tag>"
	exit 1
fi

DOCKER_PASSWORD=$(aws ecr get-login-password --region eu-west-2)

docker login --username AWS --password $DOCKER_PASSWORD 368255555983.dkr.ecr.eu-west-2.amazonaws.com
docker tag $IMAGE:$TAG 368255555983.dkr.ecr.eu-west-2.amazonaws.com/unifi-controller:latest
docker push 368255555983.dkr.ecr.eu-west-2.amazonaws.com/unifi-controller:$DOCKER_TAG


