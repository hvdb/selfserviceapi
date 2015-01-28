#!/bin/bash
d=$(date +'%Y-%m-%d %H:%M:%S')
currentDir=${PWD##*/}
username=$(whoami)
repo=ssh://git@stash.europe.intranet:7999/an/$1.git

echo "Creating directory and setting up git"
mkdir /tmp/$1
cd /tmp/$1
git init
git remote add origin $repo

echo "Created on $d" > created

git add .
git commit -m "First commit, added branches"
git push -u origin master
git checkout -b develop
git push -u origin develop
git checkout -b release-a
git push -u origin release-a
git checkout -b release-prd
git push -u origin release-prd

git checkout develop

echo "Creating directory structure"
yo submodule $1

git add --all
git commit -m "First develop commit. Adding a skeleton app."
git push -u origin develop