#!/bin/bash

# Function to get password using Rofi
get_password() {
    rofi -dmenu -p "Enter sudo password:" -password -lines 0
}

# Array of options
options=("Nvidia" "Integrated" "Hybrid")

# Show Rofi menu and get user selection
chosen=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "Select GPU Mode:")

# If a valid option was chosen, ask for password
if [[ " ${options[@]} " =~ " ${chosen} " ]]; then
    password=$(get_password)

    # Use the password to execute the command
    case "$chosen" in
        "Nvidia")
            echo "$password" | sudo -S envycontrol -s nvidia
            ;;
        "Integrated")
            echo "$password" | sudo -S envycontrol -s integrated
            ;;
        "Hybrid")
            echo "$password" | sudo -S envycontrol -s hybrid
            ;;
    esac

    # Notify user of the change
    notify-send "GPU Mode Changed" "Switched to $chosen mode"
else
    notify-send "Error" "No valid option selected."
    exit 1
fi
