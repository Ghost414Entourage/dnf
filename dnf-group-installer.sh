nano dnf-group-installer.sh



#!/bin/bash
# Interactive DNF Group Installer

# Get group list (both available + hidden), filter out headers
mapfile -t groups < <(dnf group list hidden | grep -E '^[[:space:]]{3,}[^ ].*$' | sed 's/^[[:space:]]*//')

# Display menu
echo "Available DNF Groups:"
for i in "${!groups[@]}"; do
    num=$((i+1))
    echo "  $num) ${groups[$i]}"
done

# Ask user for selection(s)
read -p "Enter the number(s) of the group(s) you want to install (space-separated): " choices

# Install each chosen group
for choice in $choices; do
    if [[ $choice =~ ^[0-9]+$ ]] && (( choice > 0 && choice <= ${#groups[@]} )); then
        group_name="${groups[$((choice-1))]}"
        echo "Installing group: $group_name"
        dnf group install -y "$group_name"
    else
        echo "Invalid choice: $choice"
    fi
done







chmod +x dnf-group-installer.sh



./dnf-group-installer.sh



