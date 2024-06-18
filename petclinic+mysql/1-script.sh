#!/bin/bash

echo ">>>>> Step 1 - Load the images"
TASKPATH="/opt/docker/final-task2"
HOMEDIR="/home/debian/final-subtask2/"

docker pull hlebsur/mysql:8
docker pull hlebsur/pet_clinic_not_full:latest
docker pull eclipse-temurin:17-jre-jammy

echo ""
echo ">>>>> Step 2 - Preparation the work directory"

sudo mkdir -p $TASKPATH
sudo cp -f $HOMEDIR* $TASKPATH/
sudo cp -f $HOMEDIR'.env' $TASKPATH/

sudo chown -R debian:debian $TASKPATH
sudo chmod -R 777 $TASKPATH

echo ""
echo "$TASKPATH content:"
ls -alg $TASKPATH
