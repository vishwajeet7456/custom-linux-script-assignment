#!/bin/bash

# Function to display version
version() {
    echo "internsctl version v0.1.0"
}

# Function to display help
show_help() {
    echo "Usage: internsctl [command] [options]"
    # Add more help text here
}

# Function for CPU information
cpu_info() {
    lscpu
}

# Function for memory information
memory_info() {
    free
}

# Function to create a new user
create_user() {
    sudo useradd -m "$1" -s /bin/bash
}

# Function to list all regular users
list_users() {
    awk -F':' '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd
}

# Function to list users with sudo permissions
list_sudo_users() {
    getent group sudo | cut -d: -f4
}

# Function to get file information
file_info() {
    if [[ "$1" == "--size" ]]; then
        stat -c%s "$2"
    elif [[ "$1" == "--permissions" ]]; then
        stat -c%A "$2"
    elif [[ "$1" == "--owner" ]]; then
        stat -c%U "$2"
    elif [[ "$1" == "--last-modified" ]]; then
        stat -c%y "$2"
    else
        stat "$1"
    fi
}

# Main command logic
case "$1" in
    --version)
        version
        ;;
    --help)
        show_help
        ;;
    cpu)
        if [ "$2" == "getinfo" ]; then
            cpu_info
        fi
        ;;
    memory)
        if [ "$2" == "getinfo" ]; then
            memory_info
        fi
        ;;
    user)
        case "$2" in
            create)
                create_user "$3"
                ;;
            list)
                if [ "$3" == "--sudo-only" ]; then
                    list_sudo_users
                else
                    list_users
                fi
                ;;
            *)
                echo "Invalid user command"
                ;;
        esac
        ;;
    file)
        if [ "$2" == "getinfo" ]; then
            file_info "$3" "$4"
        fi
        ;;
    *)
        echo "Invalid command"
        ;;
esac
