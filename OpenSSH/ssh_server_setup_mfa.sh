#!/bin/bash
google_auth_pkg='libpam-google-authenticator'
pamd_sshd=/etc/pam.d/sshd
sshd_config=/etc/ssh/sshd_config
bold=$(tput bold)
normal=$(tput sgr0)

if [[ $EUID -ne 0 ]]; then
    echo "Error: You are not root. This should be executed as root."
else

    # Check if Google Authenticator is set up in pam.d
#    google_pam=$(grep "pam_google_authenticator" ${pamd_sshd})
    if [[ -z $(grep "pam_google_authenticator" ${pamd_sshd}) ]]; then

        read -p "Do you want users to be able to log in if 2FA is not generated yet? [y]" -n 1 -r 
        if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
            nullok=' nullok'
        fi

        echo
        if echo "auth required pam_google_authenticator.so${nullok}" >> $pamd_sshd; then
            echo "Successfully added required Google auth through pam.d in ${pamd_sshd}"
        else
            echo "Error: Could not add required line to ${pamd_sshd}"
        fi
    fi

    # Deactivate password authentication
    if [[ ! -z $(grep ^"@include common-auth" ${pamd_sshd}) ]]; then
        if sed -i -e "s/^\@include common-auth/#\@include common-auth/g" $pamd_sshd; then
            echo "Successfully deactivate password authentication in pam.d"
        else
            echo "Error: Could not deactivate password authentication in pam.d"
        fi
    fi


    # Detect the parameter `ChallengeResponseAuthentication` and attempt to change the value
    challenge_response_auth=$(egrep -i '^#ChallengeResponseAuthentication|^ChallengeResponseAuthentication' $sshd_config | awk '{ print $2 }')
    echo "The parameter 'ChallengeResponseAuthentication' is set to '${challenge_response_auth}'"
    if [ $challenge_response_auth = "no" ]; then
        if sed -i -e "s/^ChallengeResponseAuthentication.*$/ChallengeResponseAuthentication yes/g" $sshd_config; then
            echo "Successfully changed 'ChallengeResponseAuthentication' to 'yes'"
        else
            echo "Error: Not able to change the 'ChallengeResponseAuthentication' to 'yes'"
        fi
    fi


    # Detect the parameter `PubkeyAuthentication` and attempt to change the value
    passwd_auth_param=$(egrep -i '^#PubkeyAuthentication|^PubkeyAuthentication' $sshd_config | awk '{ print $2 }')
    echo "The parameter 'PubkeyAuthentication' is set to '${passwd_auth_param}'"
    if [ $passwd_auth_param = "no" ]; then
        if sed -i -e "s/PubkeyAuthentication no/PubkeyAuthentication yes/g" $sshd_config; then
            echo "Successfully changed 'PubkeyAuthentication' to 'yes'"
        else
            echo "Error: Not able to change the 'PubkeyAuthentication' to 'yes'"
        fi
    fi


    # Detect the parameter `AuthenticationMethods` and attempt to change the value
    auth_methods=$(egrep -i '^#AuthenticationMethods|^AuthenticationMethods' $sshd_config | awk '{ print $2 }')
    echo "The parameter 'AuthenticationMethods' is set to '${auth_methods}'"
    if [ -z $auth_methods ]; then
        if echo "AuthenticationMethods publickey,keyboard-interactive" >> $sshd_config; then
            echo "Successfully set the parameter 'AuthenticationMethods' to 'publickey,keyboard-interactive'"
        else
            echo "Error: Unable to set the parameter 'AuthenticationMethods'"
        fi
    elif [[ -z $(grep "AuthenticationMethods publickey,keyboard-interactive" $sshd_config) ]]; then
        if sed -i -e "s/^.*AuthenticationMethods.*$/AuthenticationMethods publickey,keyboard-interactive/g" $sshd_config; then
            echo "Successfully set the parameter 'AuthenticationMethods' to 'publickey,keyboard-interactive'"
        else
            echo "Error: Unable to change the parameter 'AuthenticationMethods'"
        fi
    fi


    # Configure 2FA for `sudo`
    if [[ ! -z $(grep "^#.*pam_permit.so$" /etc/pam.d/common-auth) ]]; then
        if sed -i -e "s/^#.*pam_permit.so$/auth required pam_permit.so/g" /etc/pam.d/common-auth; then
            echo "Successfully uncommented pam_permit.so"
        else
            echo "Error: Unable to uncomment pam_permit.so"
        fi
    elif [[ -z $(grep "^auth.*pam_permit.so$" /etc/pam.d/common-auth) ]]; then
        echo "auth required pam_permit.so" >> /etc/pam.d/common-auth
    elif [[ ! -z $(grep "^auth.*pam_permit.so$" /etc/pam.d/common-auth) ]]; then
        echo "Succesfully configured pam_permit.so"
    fi
fi
