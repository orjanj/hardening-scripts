#!/bin/bash
# Hardening script for checking sysctl, auto-update, ufw settings in accordance with assignment
unattended_upgrades=/etc/apt/apt.conf.d/50unattended-upgrades
ssh_port=48721
http_port=80
https_port=443
protocol="tcp"
sysctl_params=("kernel.kptr_restrict" "kernel.dmesg_restrict" "kernel.printk" "net.ipv6.conf.all.disable_ipv6" "net.ipv6.conf.default.disable_ipv6" "net.ipv6.conf.lo.disable_ipv6")
sysctl_def=("2" "1" "3 4 1 3" "1" "1" "1")

# Import the function(s) in confirm.sh
source functions.sh

if [[ $EUID -ne 0 ]]; then
    echo "Error: You are not root. This should be executed as root."
else

    # Check if ufw is installed
    if ! command -v ufw &> /dev/null; then
        echo "ufw is not installed."
        confirm_prompt "Do you want to install ufw [y]"
        if [ $? -eq 0 ]; then
            if apt install ufw -y > /dev/null; then
                echo "Successfully installed ufw"
            else
                echo "Unable to install ufw."
                echo "Exiting the script. Try reinstalling the 'ufw' package and re-run the script."
                exit
            fi
        fi
    fi

    # Enable ufw
    ufw_status=$(systemctl status ufw | grep 'Active' | awk '{ print $2 }')
    if [[ $ufw_status != "active" ]]; then
        confirm_prompt "Do you want to enable and start ufw [y]"
        if [ $? -eq 0 ]; then
            ufw enable
            systemctl start ufw
        else
            echo "Error: You choose not to enable ufw."
            echo "Script exiting."
            exit
        fi
    else
        echo "ufw is running."
    fi

    # Check the status of ufw
    echo "UFW status before running through rules."
    confirm_prompt "Do you want to show the ufw status [y]"
    if [ $? -eq 0 ]; then
        ufw status
    fi

    # Allow all outgoing traffic
    confirm_prompt "Do you want to allow all outgoing traffic by default [y]"
    if [ $? -eq 0 ]; then
        if ufw default allow outgoing > /dev/null; then
            echo "Successfully allowed all outgoing traffic."
        else
            echo "Error: Unable to allow all outgoing traffic."
        fi
    else
        echo "Continuing with defaults."
    fi

    # Deny all incoming traffic
    confirm_prompt "Do you want to deny all incoming traffic by default [y]"
    if [ $? -eq 0 ]; then
        if ufw default deny incoming > /dev/null; then
            echo "Successfully denied all incoming traffic."
        else
            echo "Error: Unable to denied all incoming traffic."
        fi
    else
        echo "Continuing with defaults."
    fi

    # Enable firewall logging
    confirm_prompt "Do you want to enable logging [y]"
    if [ $? -eq 0 ]; then
        if ufw logging on > /dev/null; then
            echo "Successfully enabled logging."
        else
            echo "Error: Unable to enable logging."
        fi
    else
        echo "Continuing with defaults."
    fi

    # Allow traffic on HTTP port
    confirm_prompt "Do you want to allow traffic on port ${http_port} [y]"
    if [ $? -eq 0 ]; then
        if ufw allow ${http_port}/${protocol} > /dev/null; then
            echo "Successfully allowed traffic on ${http_port}/${protocol}."
        else
            echo "Error: Unable to allow traffic on ${http_port}/${protocol}."
        fi
    else
        echo "Continuing with defaults."
    fi

    # Allow traffic on HTTPS port
    confirm_prompt "Do you want to allow traffic on port ${https_port} [y]"
    if [ $? -eq 0 ]; then
        if ufw allow ${https_port}/${protocol} > /dev/null; then
            echo "Successfully allowed traffic on ${https_port}/${protocol}."
        else
            echo "Error: Unable to allow traffic on ${https_port}/${protocol}."
        fi
    else
        echo "Continuing with defaults."
    fi

    # Allow traffic on SSH port
    confirm_prompt "Do you want to allow traffic on port ${ssh_port} [y]"
    if [ $? -eq 0 ]; then
        if ufw allow ${ssh_port}/${protocol} > /dev/null; then
            echo "Successfully allowed traffic on ${ssh_port}/${protocol}."
        else
            echo "Error: Unable to allow traffic on ${ssh_port}/${protocol}."
        fi
    else
        echo "Continuing with defaults."
    fi


    # Check automatically updates
    if [ -f "${unattended_upgrades}" ]; then
        feedback=$(cat /etc/apt/apt.conf.d/50unattended-upgrades | grep "\${distro_id}:\${distro_codename}-updates")
        if [[ "$feedback" == "//"* ]]; then
            if sed -i '/^\/\/.*-updates/s/^\/\///' $unattended_upgrades; then
                echo "Updates enabled."
            else
                echo "Error: Unable to uncomment updates in ${unattended_upgrades}."
            fi
        else
            echo "Updates are active."
        fi
    fi

    # Check automatically updates
    if [ -f "${unattended_upgrades}" ]; then
        feedback=$(cat /etc/apt/apt.conf.d/50unattended-upgrades | grep "Remove-Unused-Kernel-Packages")
        if [[ "$feedback" == "//"* ]]; then
            if sed -i '/^\/\/.*Remove-Unused-Kernel-Packages/s/^\/\///' $unattended_upgrades; then
                echo "Updates enabled."
            else
                echo "Error: Unable to uncomment updates in ${unattended_upgrades}."
            fi
        else
            echo "Updates are active."
        fi
    fi

    # Check automatically updates
    if [ -f "${unattended_upgrades}" ]; then
        feedback=$(cat /etc/apt/apt.conf.d/50unattended-upgrades | grep "Remove-New-Unused-Dependencies")
        if [[ "$feedback" == "//"* ]]; then
            if sed -i '/^\/\/.*Remove-New-Unused-Dependencies/s/^\/\///' $unattended_upgrades; then
                echo "Updates enabled."
            else
                echo "Error: Unable to uncomment updates in ${unattended_upgrades}."
            fi
        else
            echo "Updates are active."
        fi
    fi

    # Check automatically updates
    if [ -f "${unattended_upgrades}" ]; then
        feedback=$(cat /etc/apt/apt.conf.d/50unattended-upgrades | grep "Automatic-Reboot ")
        if [[ "$feedback" == "//"* ]]; then
            if sed -i '/^\/\/.*Automatic-Reboot /s/^\/\///' $unattended_upgrades; then
                echo "Updates enabled."
                sed -i -e 's/^ when Unattended.*Automatic-Reboot is set to true//g' $unattended_upgrades # quickfix
            else
                echo "Error: Unable to uncomment updates in ${unattended_upgrades}."
            fi
        else
            echo "Updates are active."
        fi
    fi

    # Check automatically updates
    if [ -f "${unattended_upgrades}" ]; then
        feedback=$(cat /etc/apt/apt.conf.d/50unattended-upgrades | grep "Automatic-Reboot-Time")
        if [[ "$feedback" == "//"* ]]; then
            if sed -i '/^\/\/.*Automatic-Reboot-Time/s/^\/\///' $unattended_upgrades; then
                echo "Updates enabled."
            else
                echo "Error: Unable to uncomment updates in ${unattended_upgrades}."
            fi
        else
            echo "Updates are active."
        fi
    fi

    # Load sysctl parameters from /etc/sysctl.conf
    echo
    confirm_prompt "Do you want to load sysctl parameters [y]"
    if [ $? -eq 0 ]; then
        sysctl -p
    fi

    # Compare sysctl params
    for param in "${sysctl_params[@]}"
    do
        if [[ "$param" != "kernel.printk" ]]; then # this param should not be changed.
            sysctl $param
            confirm_prompt "Do you want to change $param [y]"
            if [ $? -eq 0 ]; then
                read -p "Enter new value: " new_value;
                if [ -z $new_value ]; then
                    echo "Error: No value given. Value not changed for ${param}."
                else
                    if sysctl -w $param=$new_value; then
                        echo "Successfully set ${param} to ${new_value}."
                    fi
                fi
            fi
        fi
    done
    echo "If any changed sysctl parameters, these will not be effective during next reboot."
    echo "The same values must be added to /etc/sysctl.conf"

    echo
    confirm_prompt "Do you want to see active sysctl parameters [y]"
    if [ $? -eq 0 ]; then
        sysctl -a
    fi

    # Enable fail2ban
    fail2ban_status=$(systemctl status fail2ban | grep 'Active' | awk '{ print $2 }')
    if [[ $fail2ban_status != "active" ]]; then
        confirm_prompt "Do you want to start fail2ban [y]"
        if [ $? -eq 0 ]; then
            systemctl start fail2ban
        else
            echo "Error: You choose not to start fail2ban."
            echo "Script exiting."
            exit
        fi
    else
        echo "fail2ban is running."
    fi
fi