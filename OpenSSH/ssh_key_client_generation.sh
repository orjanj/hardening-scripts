#!/bin/bash
# Script by Ørjan Jacobsen <oaj@oaj.guru>
ssh_key_dir=$HOME/.ssh
key_name=id_rsa

function prompt_view_keys() {
    ssh_dir=$1
    key=$2
    read -p "Do you want to view your private key? [n]" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f "$ssh_dir/$key" ]; then
            echo "Your SSH private key:"
            cat $ssh_dir/$key
        fi
    fi

    read -p "Do you want to view your public key? [n]" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f "$ssh_dir/$key.pub" ]; then
            echo "Your SSH public key:"
            cat $ssh_dir/$key.pub
        fi
    fi
}

read -p "Do you want to create a SSH keypair? [y]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ssh-keygen -t rsa -f "${ssh_key_dir}/${key_name}"; then
        echo "SSH keypair successfully generated."
        echo "You will find your keypair in ${ssh_key_dir}/"
        prompt_view_keys $ssh_key_dir $key_name
    else
        echo "Error: SSH keypair generation failed."
        echo "Please retry the key generation."
    fi
else
    # Check if keypair actually exists
    if [ -f "$ssh_key_dir/$key_name.pub" ]; then
        echo "SSH keypair detected: ${ssh_key_dir}/"
        prompt_view_keys $ssh_key_dir $key_name
    else
        echo "Error: SSH keypair not found"
        echo "You have to create a SSH keypair to continue."
    fi
fi
