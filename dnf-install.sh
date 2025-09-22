#!/bin/bash

# Require a search term
if [ -z "$1" ]; then
    echo "Usage: $0 <search-term>"
    exit 1
fi

SEARCH_TERM="$1"

# Run dnf search, filter only package result lines
mapfile -t results < <(dnf search "$SEARCH_TERM" | grep -E '^[a-zA-Z0-9._+-]+')

if [ ${#results[@]} -eq 0 ]; then
    echo "No results found for '$SEARCH_TERM'."
    exit 1
fi

# Show results with numbers
echo "Packages found for '$SEARCH_TERM':"
for i in "${!results[@]}"; do
    echo "$((i+1))) ${results[$i]}"
done

# Ask user for choices
read -p "Enter the number(s) of the package(s) you want to install (space-separated): " -a choices

# Build package list
pkgs=()
for choice in "${choices[@]}"; do
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -le 0 ] || [ "$choice" -gt ${#results[@]} ]; then
        echo "Skipping invalid choice: $choice"
        continue
    fi
    pkg=$(echo "${results[$((choice-1))]}" | awk '{print $1}')
    pkgs+=("$pkg")
done

if [ ${#pkgs[@]} -eq 0 ]; then
    echo "No valid packages selected."
    exit 1
fi

# Confirm and install
echo "Installing packages: ${pkgs[*]}"
sudo dnf install -y "${pkgs[@]}"






chmod +x dnf-install.sh

./dnf-install.sh



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


