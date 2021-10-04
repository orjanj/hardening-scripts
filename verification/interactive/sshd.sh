#!/bin/bash
pamd_sshd=/etc/pam.d/sshd
sshd_config=/etc/ssh/sshd_config
bold=$(tput bold)
normal=$(tput sgr0)

# Import the function(s) in confirm.sh
source functions.sh

if [[ $EUID -ne 0 ]]; then
    echo "Error: You are not root. This should be executed as root."
else

    # Check if it exists a public and private key in a users home directory
    echo "Checking if key pair exists in a users home directory"
    read -p "Enter username: " username;
    if [ -z $username ]; then
        echo "Error: No username given. Exiting script."
        exit
    fi

    if [[ -z $(grep $username /etc/passwd) ]]; then
        echo "Error: User does not exist. Script exiting."
        exit
    fi

    # Prompt the user for a key pair name
    read -p "Enter key pair name [id_rsa]: " keyname

    # Check if keyname input is blank - if so, set the default
    if [ -z $keyname ]; then
        keyname='id_rsa'
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
    confirm_prompt "Do you want to change this port [y]"
    if [ $? -eq 0 ]; then
        str_replace regex.test "^(#Port|Port).*$" "Port ${port}" # TODO: Fix regex
        [[ $? -eq 0 ]] && echo "Sucessfully changed SSH parameter to ${port}" || echo "Error: Could not change SSH parameter to ${port}."
    fi


    # To be implemented:
    # ListenAddress
    # LoginGraceTime
    # PermitRootLogin
    # X11Forwarding
    # AllowGroups
    # PasswordAuthentication


    # Prompt user to show the SSHd configuration
    confirm_prompt "Do you want to view the SSHd config [y]"
    if [ $? -eq 0 ]; then
        echo "Viewing running SSHd configuration:"
        sshd -T
    else
        echo "Not reviewing SSHd configuration."
    fi

    # Review users members of adm/sudo

fi