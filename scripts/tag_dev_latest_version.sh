#!/bin/bash

IMAGE=$1
TAG=$2

if [ -z $TAG ]
then
	echo "Usage: $0 <image> <default tag>"
	exit 1
fi


if [ $TAG == latest ]
then
	TAG_PREFIX=""
elif [ $TAG == "dev" ]
then
	TAG_PREFIX="dev-"
elif [ $TAG == "nocache" ]
then
	TAG_PREFIX="nocache-"
else
	echo "Unsupported tag $TAG" 1>&2
	exit 0
fi
#hjs@cortado:~/Dev/docker-unifi-controller/scripts$ docker cp $id:/unifi-version -
#unifi-version0100644000000000000000000000003014126015204011751 0ustar0000000000000000Version: 6.4.54-16067-1
id=$(docker create $IMAGE:$TAG)
vnstr=$(docker cp $id:/unifi-version -)
unifi_version=$(cut -f2 -d: <<< $vnstr | cut -f1 -d- | xargs)
echo Detected Unifi Version $unifi_version
NEW_TAG=$TAG_PREFIX$unifi_version
echo Retagging as $NEW_TAG

echo docker  tag $IMAGE:$TAG $IMAGE:$NEW_TAG
echo docker push lumel/unifi-controller:$NEW_TAG

docker rm $id

