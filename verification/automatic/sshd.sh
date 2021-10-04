#!/bin/bash
pamd_sshd=/etc/pam.d/sshd
sshd_config=/etc/ssh/sshd_config
bold=$(tput bold)
normal=$(tput sgr0)
username=orrie
keyname=id_rsa

# Import the function(s) in confirm.sh
source functions.sh

if [[ $EUID -ne 0 ]]; then
    echo "Error: You are not root. This should be executed as root."
else

    # Check if it exists a public and private key in a users home directory
    echo "Checking if key pair exists in a users home directory"
    if [[ -z $(grep $username /etc/passwd) ]]; then
        echo "Error: User does not exist. Script exiting."
        exit
    fi

    # Check if the key pair exists in the users home directory
    if [ -f "/home/${username}/.ssh/${keyname}" ]; then
        echo "Successfully found key pair with the name ${keyname}."
    else
        echo "Error: Unable to find key pair with name ${keyname}."
    fi

    # Checking SSH port, prompt user for changing the port and change the port if chosen.
    get_param_from_file $sshd_config "^#Port|^Port"
    port=$?
    echo "SSH port is set to: ${port}"

    # To be implemented:
    # Port
    # ListenAddress
    # LoginGraceTime
    # PermitRootLogin
    # X11Forwarding
    # AllowGroups
    # PasswordAuthentication

    sshd -T
fi