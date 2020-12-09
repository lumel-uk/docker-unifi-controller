#!/bin/bash

if [ -z $1 ]
then
	echo "Usage: $0 <version>" 1>&2
	echo "    e.g. $0 6.0.41" 1>&2
	exit 1
fi

git tag -a $1 -m $1
git push --tags

