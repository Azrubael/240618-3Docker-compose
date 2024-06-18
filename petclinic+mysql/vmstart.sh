#!/bin/bash

# sudo chmod +x *.sh

VBoxManage startvm docker-lab --type headless

while ! VBoxManage showvminfo docker-lab | grep -q "running"; do
    sleep 2
done

DSTDIR='/home/debian/final-subtask2/'
while ! ssh debian@192.168.56.7 "mkdir -p $DSTDIR"; do
    sleep 2
done


scp * debian@192.168.56.7:"$DSTDIR"
scp '.env' debian@192.168.56.7:"$DSTDIR"

ssh -i '/home/az/.ssh/epam-lab' debian@192.168.56.7