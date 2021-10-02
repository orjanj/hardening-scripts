#!/bin/bash
google_auth_pkg='libpam-google-authenticator'
bold=$(tput bold)
normal=$(tput sgr0)

# Check if the libpam-google-authenticator package is installed
if dpkg -l | grep $google_auth_pkg > /dev/null; then
    echo "${google_auth_pkg} is installed."
#elif sudo apt install $google_auth_pkg -y > /dev/null; then
#    echo "Successfully installed ${google_auth_pkg}."
else
    echo "Error: ${google_auth_pkg} is not installed."
    exit
fi

# Window size
read -p "Enter determined window size for tokens [3]: " -n 1 -r window_size
# Set default window size if parameter is blank
if [ -z $window_size ]; then
    window_size=3
fi

# Backup codes
read -p "Enter number of emergency backup codes [10]: " -r backup_codes
# Set default number of backup codes
if [ -z $backup_codes ]; then
    backup_codes=10
fi

# Allowed logins pr. x second
read -p "Enter number of allowed logins every 30 seconds [3]: " -r allowed_logins
# Set default number of allowed logins
if [ -z $allowed_logins ]; then
    allowed_logins=3
fi

# View Google Authenticator configurations
echo
echo "${bold}Viewing Google authenticator configuration:${normal}"
echo "Using TOTP authentication"
echo "Writing configuration to: ~/.google_authenticator"
echo "Allowing reuse of previously used tokens"
echo "${bold}Allowed window size:${normal} ${window_size}"
echo "Generating ${backup_codes} backup codes"
echo "Allowing ${allowed_logins} logins each 30 seconds"
echo

# Prompt user for continue with config and run `google-authenticator`
read -p "Continue with this configuration [y]?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
    if google-authenticator -t -f -d -w $window_size -e $backup_codes -r $allowed_logins -R 30; then
        echo
        echo "Successfully set up google-authenticator."
    else
        echo "Error: Stopped google-authenticator due to user input."
    fi
else
    echo
    echo "Script stopped due to user input."
    exit
fi