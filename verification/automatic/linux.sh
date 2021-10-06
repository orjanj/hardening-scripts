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
        if apt install ufw -y > /dev/null; then
            echo "Successfully installed ufw"
        else
            echo "Unable to install ufw."
            echo "Exiting the script. Try reinstalling the 'ufw' package and re-run the script."
            exit
        fi
    fi

    # Enable ufw
    ufw_status=$(systemctl status ufw | grep 'Active' | awk '{ print $2 }')
    if [[ $ufw_status != "active" ]]; then
        ufw enable
        systemctl start ufw
    else
        echo "ufw is running."
    fi

    # Check the status of ufw
    echo "UFW status before running through rules."
    ufw status

    # Allow all outgoing traffic
    if ufw default allow outgoing > /dev/null; then
        echo "Successfully allowed all outgoing traffic."
    else
        echo "Error: Unable to allow all outgoing traffic."
    fi

    # Deny all incoming traffic
    if ufw default deny incoming > /dev/null; then
        echo "Successfully denied all incoming traffic."
    else
        echo "Error: Unable to denied all incoming traffic."
    fi

    # Enable firewall logging
    if ufw logging on > /dev/null; then
        echo "Successfully enabled logging."
    else
        echo "Error: Unable to enable logging."
    fi

    # Allow traffic on HTTP port
    if ufw allow ${http_port}/${protocol} > /dev/null; then
        echo "Successfully allowed traffic on ${http_port}/${protocol}."
    else
        echo "Error: Unable to allow traffic on ${http_port}/${protocol}."
    fi

    # Allow traffic on HTTPS port
    if ufw allow ${https_port}/${protocol} > /dev/null; then
        echo "Successfully allowed traffic on ${https_port}/${protocol}."
    else
        echo "Error: Unable to allow traffic on ${https_port}/${protocol}."
    fi

    # Allow traffic on SSH port
    if ufw allow ${ssh_port}/${protocol} > /dev/null; then
        echo "Successfully allowed traffic on ${ssh_port}/${protocol}."
    else
        echo "Error: Unable to allow traffic on ${ssh_port}/${protocol}."
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
    echo "Viewing sysctl.conf:"
#    sysctl -a

    # Enable fail2ban
    fail2ban_status=$(systemctl status fail2ban | grep 'Active' | awk '{ print $2 }')
    if [[ $fail2ban_status != "active" ]]; then
        systemctl start fail2ban
    else
        echo "fail2ban is running."
    fi
fi