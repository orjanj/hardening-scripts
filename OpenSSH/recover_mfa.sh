#!/bin/bash
# Check if the user is root
if [[ $EUID -ne 0 ]]; then
    echo "Error: You are not root. This should be executed as root."

# If the user is root, continue
else
    username=$1

    # If the input for the script is blank - return help menu
    if [ -z $username ]; then
        echo "Script usage: bash $0 <username>";

    # Check if it already exists an Google Authenticator file and remove the MFA for the user
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