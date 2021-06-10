#!/bin/bash

TAG=$1
if [ -z $TAG ]
then
	CURRENT_BRANCH=$(git status | grep 'On branch' | cut -f3 -d\  ) 
	if [ $CURRENT_BRANCH == "dev" ]
	then
		TAG="dev"
	else
		TAG=latest
	fi
fi


if [ $TAG != latest -a $TAG != dev ]
then
	git tag -a $1 -m $1
	git push --tags
fi

docker build -t lumel/unifi-controller:$TAG .
docker push lumel/unifi-controller:$TAG

