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
# elif [ $TAG == "dev" ]
#then
#	TAG_PREFIX="dev-"
#elif [ $TAG == "nocache" ]
#then
#	TAG_PREFIX="nocache-"
else
	echo "Unsupported tag $TAG" 1>&2
	exit 0
fi

id=$(docker create $IMAGE:$TAG)
vnstr=$(docker cp $id:/unifi-version -)
unifi_version=$(cut -f2 -d: <<< $vnstr | cut -f1 -d- | xargs)
echo Detected Unifi Version $unifi_version

NEW_TAG=$TAG_PREFIX$unifi_version
echo Retagging as $NEW_TAG
docker  tag $IMAGE:$TAG $IMAGE:$NEW_TAG

echo Pushing image
docker push --all-tags lumel/unifi-controller

docker rm $id

