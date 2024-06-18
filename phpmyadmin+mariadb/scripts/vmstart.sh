#!/bin/bash

# sudo chmod +x *.sh

VBoxManage startvm docker-lab --type headless

while ! VBoxManage showvminfo docker-lab | grep -q "running"; do
    sleep 2
done

SRCDIR='/opt/CODE/EPAM/DevOps-Advanced/Docker-L5/Compose12-14_v1/'
DSTDIR='/home/debian/compose/compose12-14_v1/'
while ! ssh debian@192.168.56.7 "mkdir -p $DSTDIR"; do
    sleep 2
done


scp "$SRCDIR"* debian@192.168.56.7:"$DSTDIR"
scp "$SRCDIR"'.env' debian@192.168.56.7:"$DSTDIR"

ssh -i '/home/az/.ssh/epam-lab' debian@192.168.56.7