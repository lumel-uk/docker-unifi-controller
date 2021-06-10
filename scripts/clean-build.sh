#!/bin/bash

TMP=$(mktemp -d)

echo Cloning into $TMP
git clone https://github.com/lumel-uk/docker-unifi-controller.git $TMP
cd $TMP

scripts/tag.sh

cd / 

echo Removing $TMP
rm -rf $TMP


