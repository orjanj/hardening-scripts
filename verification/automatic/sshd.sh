#!/bin/bash
pamd_sshd=/etc/pam.d/sshd
sshd_config=/etc/ssh/sshd_config
ssh_port=48721
nic=ens33
grace_time="1m"
permit_root="no"
x11_forward="no"
allow_groups="ssh"
passwd_auth="no"
auth_method="publickey,keyboard-interactive"
challenge_resp_auth="yes"
pubkey_auth="yes"
username="cnd"
keyname="id_rsa"

# Get the IP address for the NIC for later use
if_ip=$(ip address show $nic | grep 'inet ' | awk -F '/' '{ print $1 }' | awk '{ print $2 }')

# Import the function(s) in confirm.sh
source functions.sh

if [[ $EUID -ne 0 ]]; then
    echo "Error: You are not root. This should be executed as root."
else

    # Check if it exists a public and private key in a users home directory
    echo "Checking if key pair exists in a users home directory"
    if [ -z $username ]; then
        echo "Error: No username given. Exiting script."
        exit
    fi

    if [[ -z $(grep $username /etc/passwd) ]]; then
        echo "Error: User does not exist. Script exiting."
        exit
    fi

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

    # Remove the duplicate ListenAddress line containing listening on everything
    str_replace $sshd_config "^#ListenAddress ::" ""

    # Check the Port parameter and attempt to change it if default
    feedback=$(get_param_from_file $sshd_config "^#Port|^Port")
    if [ ! -z $feedback ]; then
        echo "SSH port is set to: ${feedback}"
        str_replace $sshd_config "\(^#Port\|^Port\).*$" "Port ${ssh_port}"
        [[ $? -eq 0 ]] && echo "Sucessfully changed SSH parameter to ${ssh_port}" || echo "Error: Could not change SSH parameter to ${ssh_port}."
    else
        if echo "Port ${ssh_port}" >> $sshd_config; then
            echo "Successfully added Port parameter ${ssh_port} to ${sshd_config}"
        else
            echo "Error: Could not add Port parameter ${ssh_port} to ${sshd_config}"
        fi
    fi

    # Check the ListenAddress parameter and attempt to change it if default
    feedback=$(get_param_from_file $sshd_config "^#ListenAddress|^ListenAddress")
    if [ ! -z $feedback ]; then
        echo "ListenAddress is set to: ${feedback}"
        str_replace $sshd_config "\(^#ListenAddress\|^ListenAddress\).*$" "ListenAddress ${if_ip}"
        [[ $? -eq 0 ]] && echo "Sucessfully changed ListenAddress parameter to ${if_ip}" || echo "Error: Could not change ListenAddress parameter to ${if_ip}."
    else
        if echo "ListenAddress ${if_ip}" >> $sshd_config; then
            echo "Successfully added ListenAddress parameter ${if_ip} to ${sshd_config}"
        else
            echo "Error: Could not add ListenAddress parameter ${if_ip} to ${sshd_config}"
        fi
    fi

    # Check the LoginGraceTime parameter and attempt to change it if default
    feedback=$(get_param_from_file $sshd_config "^#LoginGraceTime|^LoginGraceTime")
    if [ ! -z $feedback ]; then
        echo "LoginGraceTime is set to: ${feedback}"
        str_replace $sshd_config "\(^#LoginGraceTime\|^LoginGraceTime\).*$" "LoginGraceTime ${grace_time}"
        [[ $? -eq 0 ]] && echo "Sucessfully changed LoginGraceTime parameter to ${grace_time}" || echo "Error: Could not change LoginGraceTime parameter to ${grace_time}."
    else
        if echo "LoginGraceTime ${grace_time}" >> $sshd_config; then
            echo "Successfully added LoginGraceTime parameter ${grace_time} to ${sshd_config}"
        else
            echo "Error: Could not add LoginGraceTime parameter ${grace_time} to ${sshd_config}"
        fi
    fi

    # Check the PermitRoot parameter and attempt to change it if default
    feedback=$(get_param_from_file $sshd_config "^#PermitRootLogin|^PermitRootLogin")
    if [ ! -z $feedback ]; then
        echo "PermitRootLogin is set to: ${feedback}"
        str_replace $sshd_config "\(^#PermitRootLogin\|^PermitRootLogin\).*$" "PermitRootLogin ${permit_root}"
        [[ $? -eq 0 ]] && echo "Sucessfully changed PermitRootLogin parameter to ${permit_root}" || echo "Error: Could not change PermitRootLogin parameter to ${permit_root}."
    else
        if echo "PermitRootLogin ${permit_root}" >> $sshd_config; then
            echo "Successfully added PermitRootLogin parameter ${permit_root} to ${sshd_config}"
        else
            echo "Error: Could not add PermitRootLogin parameter ${permit_root} to ${sshd_config}"
        fi
    fi

    # Check the X11Forwarding parameter and attempt to change it if default
    feedback=$(get_param_from_file $sshd_config "^#X11Forwarding|^X11Forwarding")
    if [ ! -z $feedback ]; then
        echo "X11Forwarding is set to: ${feedback}"
        str_replace $sshd_config "\(^#X11Forwarding\|^X11Forwarding\).*$" "X11Forwarding ${x11_forward}"
        [[ $? -eq 0 ]] && echo "Sucessfully changed X11Forwarding parameter to ${x11_forward}" || echo "Error: Could not change X11Forwarding parameter to ${x11_forward}."
    else
        if echo "X11Forwarding ${x11_forward}" >> $sshd_config; then
            echo "Successfully added X11Forwarding parameter ${x11_forward} to ${sshd_config}"
        else
            echo "Error: Could not add X11Forwarding parameter ${x11_forward} to ${sshd_config}"
        fi
    fi

    # Check the AllowGroups parameter and attempt to change it if default
    feedback=$(get_param_from_file $sshd_config "^#AllowGroups|^AllowGroups")
    if [ ! -z $feedback ]; then
        echo "AllowGroups is set to: ${feedback}"
        str_replace $sshd_config "\(^#AllowGroups\|^AllowGroups\).*$" "AllowGroups ${allow_groups}"
        [[ $? -eq 0 ]] && echo "Sucessfully changed AllowGroups parameter to ${allow_groups}" || echo "Error: Could not change AllowGroups parameter to ${allow_groups}."
    else
        if echo "AllowGroups ${allow_groups}" >> $sshd_config; then
            echo "Successfully added AllowGroups parameter ${allow_groups} to ${sshd_config}"
        else
            echo "Error: Could not add AllowGroups parameter ${allow_groups} to ${sshd_config}"
        fi
    fi

    # Check the PasswordAuthentication parameter and attempt to change it if default
    feedback=$(get_param_from_file $sshd_config "^#PasswordAuthentication|^PasswordAuthentication")
    if [ ! -z $feedback ]; then
        echo "PasswordAuthentication is set to: ${feedback}"
        str_replace $sshd_config "\(^#PasswordAuthentication\|^PasswordAuthentication\).*$" "PasswordAuthentication ${passwd_auth}"
        [[ $? -eq 0 ]] && echo "Sucessfully changed PasswordAuthentication parameter to ${passwd_auth}" || echo "Error: Could not change PasswordAuthentication parameter to ${passwd_auth}."
    else
        if echo "PasswordAuthentication ${passwd_auth}" >> $sshd_config; then
            echo "Successfully added PasswordAuthentication parameter ${passwd_auth} to ${sshd_config}"
        else
            echo "Error: Could not add PasswordAuthentication parameter ${passwd_auth} to ${sshd_config}"
        fi
    fi

    # Check the AuthenticationMethods parameter and attempt to change it if default
    feedback=$(get_param_from_file $sshd_config "^#AuthenticationMethods|^AuthenticationMethods")
    if [ ! -z $feedback ]; then
        echo "AuthenticationMethods is set to: ${feedback}"
        str_replace $sshd_config "\(^#AuthenticationMethods\|^AuthenticationMethods\).*$" "AuthenticationMethods ${auth_method}"
        [[ $? -eq 0 ]] && echo "Sucessfully changed AuthenticationMethods parameter to ${auth_method}" || echo "Error: Could not change AuthenticationMethods parameter to ${auth_method}."
    else
        if echo "AuthenticationMethods ${auth_method}" >> $sshd_config; then
            echo "Successfully added AuthenticationMethods parameter ${auth_method} to ${sshd_config}"
        else
            echo "Error: Could not add AuthenticationMethods parameter ${auth_method} to ${sshd_config}"
        fi
    fi

    # Check the ChallengeResponseAuthentication parameter and attempt to change it if default
    feedback=$(get_param_from_file $sshd_config "^#ChallengeResponseAuthentication|^ChallengeResponseAuthentication")
    if [ ! -z $feedback ]; then
        echo "ChallengeResponseAuthentication is set to: ${feedback}"
        str_replace $sshd_config "\(^#ChallengeResponseAuthentication\|^ChallengeResponseAuthentication\).*$" "ChallengeResponseAuthentication ${challenge_resp_auth}"
        [[ $? -eq 0 ]] && echo "Sucessfully changed ChallengeResponseAuthentication parameter to ${challenge_resp_auth}" || echo "Error: Could not change ChallengeResponseAuthentication parameter to ${challenge_resp_auth}."
    else
        if echo "ChallengeResponseAuthentication ${challenge_resp_auth}" >> $sshd_config; then
            echo "Successfully added ChallengeResponseAuthentication parameter ${challenge_resp_auth} to ${sshd_config}"
        else
            echo "Error: Could not add ChallengeResponseAuthentication parameter ${challenge_resp_auth} to ${sshd_config}"
        fi
    fi

    # Check the PubkeyAuthentication parameter and attempt to change it if default
    feedback=$(get_param_from_file $sshd_config "^#PubkeyAuthentication|^PubkeyAuthentication")
    if [ ! -z $feedback ]; then
        echo "PubkeyAuthentication is set to: ${feedback}"
        str_replace $sshd_config "\(^#PubkeyAuthentication\|^PubkeyAuthentication\).*$" "PubkeyAuthentication ${pubkey_auth}"
        [[ $? -eq 0 ]] && echo "Sucessfully changed PubkeyAuthentication parameter to ${pubkey_auth}" || echo "Error: Could not change PubkeyAuthentication parameter to ${pubkey_auth}."
    else
        if echo "PubkeyAuthentication ${pubkey_auth}" >> $sshd_config; then
            echo "Successfully added PubkeyAuthentication parameter ${pubkey_auth} to ${sshd_config}"
        else
            echo "Error: Could not add PubkeyAuthentication parameter ${pubkey_auth} to ${sshd_config}"
        fi
    fi

    # Check if the user are member of the group adm
    check_if_content_exists /etc/group "^adm.*${username}.*$"
    if [ $? -ne 0 ]; then
        add_user_to_group adm $username
    fi

    # Check if the user are member of the group ssh
    check_if_content_exists /etc/group "^ssh.*${username}.*$"
    if [ $? -ne 0 ]; then
        add_user_to_group ssh $username
    fi

    # Check if the user are member of the group sudo
    check_if_content_exists /etc/group "^sudo.*${username}.*$"
    if [ $? -ne 0 ]; then
        add_user_to_group sudo $username
    fi

    # Prompt user to show the SSHd configuration
    echo
    echo "Viewing running SSHd configuration:"
#    sshd -T
fi