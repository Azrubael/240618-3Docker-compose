#!/bin/bash

echo ">>>>> Step 0 - Preparations"
TASKPATH="/opt/docker/dockercompose"
docker pull phpmyadmin:5.2.0-apache
docker pull mariadb:lts

sudo mkdir -p $TASKPATH
cp -f * $TASKPATH/
cp -f ../Dockerfile* $TASKPATH/
cp -f "$SRC"'.env' $TASKPATH/

sudo chown -R debian:debian $TASKPATH
sudo chmod -R 777 $TASKPATH

ls -l $TASKPATH
