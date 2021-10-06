#!/bin/bash
# Hardening script for checking Apache settings in accordance with assignment
apache_dir=/etc/apache2
available_sites=$apache_dir/sites-available
enabled_sites=$apache_dir/sites-enabled
site_config=cnd-site.conf
orig_config=cnd-orig.conf
ssl_key=apache-signed.key
ssl_crt=apache-signed.crt
ssl_key_path=/etc/ssl/private/$ssl_key
ssl_crt_path=/etc/ssl/certs/$ssl_crt
apache_mods=("headers" "ssl" "socache_shmcb" "rewrite")
server_name=$HOSTNAME

# Deliery configurations
delivery_config_path=../../delivery-configurations

# Import the function(s) in confirm.sh
source functions.sh

if [[ $EUID -ne 0 ]]; then
    echo "Error: You are not root. This should be executed as root."
else

    # Check if the default enabled HTTP site are running
    if [ -f "${enabled_sites}/000-default.conf" ]; then
        a2dissite 000-default.conf
    else
        echo "Default HTTP site is NOT running."
    fi

    # Check if the default enabled HTTPS site are running
    if [ -f "${enabled_sites}/default-ssl.conf" ]; then
        a2dissite default-ssl.conf
    else
        echo "Default HTTP site is NOT running."
    fi

    # Check if the cnd site are running
    if [ ! -f "${enabled_sites}/${site_config}" ]; then
        a2ensite $site_config
    else
        echo "CND site is already running."
    fi

    site_path="${enabled_sites}/${site_config}"

    # Check file existence of delivered config
    if [ -f "${delivery_config_path}/${orig_config}" ]; then
        echo "Delivered config file is found ${orig_config}"
    else
        echo "Error: Delivered config file not found."
        echo "Please add the delivered config to the folder 'delivery-configurations'"
        echo "The Apache config file must be renamed to 'cnd-orig.conf' within this directory."
        echo "Script is exiting. Run the script again when the delivered config file exists in the mentioned directory."
        exit
    fi

    # Check diff for the delivered Apache file with the server version
    if ! diff -q $site_path $orig_config &>/dev/null; then
        echo "There is an difference between delivered config and running config file"
        if cp $orig_config $site_path; then
            echo "Overwritten running config with delivered config."
        else
            echo "Error: Unable to overwrite the running config."
        fi
    else
        echo "No difference between delivered config file and running config file."
    fi

    # Check existence of SSL private key
    if [ -f "${ssl_key_path}" ]; then
        echo "Private key exists in ${ssl_key_path}"
    else
        if [ -f "${delivery_config_path}/${ssl_key}" ]; then
            if cp "$delivery_config_path}/${ssl_key}" $ssl_key_path; then
                echo "Successfully copied private key to ${ssl_key_path}."
            else
                echo "Error: Could not copy the private key to ${ssl_key_path}."
            fi
        else
            echo "Could not find the ${ssl_key} in ${delivery_config_path}."
        fi
    fi

    # Check existence of SSL public key
    if [ -f "${ssl_crt_path}" ]; then
        echo "Public key exists in ${ssl_crt_path}"
    else
        echo "Error: Public key does not exists in ${ssl_crt_path}."
        echo "Make sure the ${ssl_crt} are located in the delivery configurations directory before proceeding."
        echo "The key must be named ${ssl_crt}."
        if [ -f "${delivery_config_path}/${ssl_crt}" ]; then
            if cp "${delivery_config_path}/${ssl_crt}" $ssl_crt_path; then
                echo "Successfully copied public key to ${ssl_crt_path}."
            else
                echo "Error: Could not copy the public key to ${ssl_crt_path}."
            fi
        else
            echo "Could not find the ${ssl_crt} in ${delivery_config_path}."
        fi
    fi

    # Check if the Apache config contains ServerName
    check_if_content_exists $site_path "ServerName"
    if [ $? -ne 0 ]; then
        echo "Configuration file does not contain ServerName."
        if echo "ServerName ${server_name}" >> $site_path; then
            echo "Successfully added ServerName to the ${site_path}."
        else
            echo "Error: Could not add the ServerName to the ${site_path}."
        fi
    fi

    # Check if the given Apache modules are enabled
    for module in "${apache_mods[@]}"
    do
        if [ -f "${apache_dir}/mods-enabled/${module}.load" ]; then
            echo "Module running: ${module}"
        else
            echo "Module not running: ${module} (it must run to make the site work)"
            if a2enmod $module; then
                echo "Successfully enabled ${module}."
            else
                echo "Error: Unable to enable module ${module}."
                exit
            fi
        fi
    done
fi