#!/bin/bash

vm='docker-lab'

VBoxManage controlvm $vm poweroff
echo "$vm virtual machine stopped"

echo "Do you want restore the last snapshot?"
input=""
while [[ -z "$input" ]]; do
    read -n 1 -r -p "Enter 'y/n': " input
    if [ "$input" == "y" ]; then
        echo ""
        VBoxManage snapshot $vm restorecurrent
        echo "The last snapshot restored"
        break
    fi
    if [ "$input" == "n" ]; then
        echo ""
        echo "Snapshot not restored"
        break
    fi
done


