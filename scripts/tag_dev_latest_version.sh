#!/bin/bash

#
# Script takes the tag specified on the command line and re-tags
# it using the UniFi package version
#
IMAGE=$1
TAG=$2

if [ -z $TAG ]
then
	echo "Usage: $0 <image> <default tag>"
	exit 1
fi


if [ $TAG == dev ]
then
	echo "Not double-tagging Dev _${TAG}_" 1>&2
	exit 0
fi
TAG_PREFIX=""

id=$(docker create $IMAGE:$TAG)
unifi_version=$(docker cp $id:/unifi-version - | cut -f2 -d: | cut -f1 -d- | xargs echo)
echo Detected Unifi Version $unifi_version

NEW_TAG=$TAG_PREFIX$unifi_version
echo Retagging as $NEW_TAG
docker  tag $IMAGE:$TAG $IMAGE:$NEW_TAG

docker rm $id

