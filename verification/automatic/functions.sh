#!/bin/bash

# Create a prompt function
function confirm_prompt() {
    prompt_text=$1
    read -p "${prompt_text}?" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [ -z $REPLY ]; then
        if [ ! -z $REPLY ]; then
            echo # fix newline issue
        fi
        return 0 # exit code 0 is true in bash
    else
        echo # fix newline issue
        return 1
    fi
}

# Check if a file contains a specific string
function check_if_content_exists() {
    file_path=$1
    file_contains=$2

    [[ ! -z $(egrep -i "${file_contains}" ${file_path} > /dev/null) ]] && return 0 || return 1

}

# Get a specific parameter from a file
function get_param_from_file() {
    file_path=$1
    regex=$2
    config_param=$(egrep -i "$regex" $file_path | awk '{ print $2 }')
    echo $config_param
}

# Replace content in file
function str_replace() {
    file_path=$1
    old_regex=$2
    new_regex=$3
    if sed -i -e "s/${old_regex}/${new_regex}/g" $file_path; then
        return 0
    else
        return 1
    fi
}

# Add a user to a group
function add_user_to_group(){
    group=$1
    username=$2

    if gpasswd -a $username $group; then
#        echo "Successfully added ${username} to ${group}"
        return 0
    else
#        echo "Error: Unable to add ${username} to ${group}"
        return 1
    fi
}
