#!/bin/bash
# Script by Ørjan Jacobsen <oaj@oaj.guru>
if [[ $EUID -ne 0 ]]; then
    echo "Error: You are not root. This should be executed as root."
else
    username=$1
    if [ -z $username ]; then
        echo "Script usage: bash $0 <username>";
    else
        if [ -f "/home/${username}/.google_authenticator" ]; then
            echo "Found google authenticator file for the user ${username}."
            read -p "Are you sure you want to remove the MFA for user ${username}? [y]" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
                if rm -rf /home/$username/.google_authenticator; then
                    echo "Removing MFA for user ${username}"
                else
                    echo "Error: An error occured when trying to recover MFA for user ${username}."
                fi
            else
                echo "Error: Could not remove MFA for user ${username}."
            fi
        else
            echo "Did not find any google authenticator file for the user ${username}."
        fi
    fi
fi