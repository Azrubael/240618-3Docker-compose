#!/bin/bash

echo ">>>>> Step 1 - Preparations"
# SRCPATH=/opt/docker/source/final-task-1/
TASKPATH="/opt/docker/final-task1"
HOMEDIR="/home/debian/final-subtask1/"

docker pull wordpress:latest
docker pull mysql:5.7

sudo mkdir -p $TASKPATH
# sudo cp -fr $SRCPATH* $TASKPATH/
sudo cp -f $HOMEDIR* $TASKPATH/

sudo chown -R debian:debian $TASKPATH
sudo chmod -R 777 $TASKPATH
mv -f $TASKPATH/env $TASKPATH'/.env'

echo "$TASKPATH content:"
ls -alg $TASKPATH
