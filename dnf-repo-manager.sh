

nano dnf-repo-manager.sh








#!/bin/bash
# Interactive DNF Repo Manager

# Get repo list (all, with status)
mapfile -t repos < <(dnf repolist --all | awk 'NR>1 {print $1 " " $NF}')

echo "Available DNF Repositories:"
for i in "${!repos[@]}"; do
    num=$((i+1))
    repo_id=$(echo "${repos[$i]}" | awk '{print $1}')
    status=$(echo "${repos[$i]}" | awk '{print $2}')
    echo "  $num) $repo_id  [$status]"
done

echo
read -p "Enter the number(s) of the repo(s) you want to toggle (space-separated): " choices

for choice in $choices; do
    if [[ $choice =~ ^[0-9]+$ ]] && (( choice > 0 && choice <= ${#repos[@]} )); then
        repo_id=$(echo "${repos[$((choice-1))]}" | awk '{print $1}')
        status=$(echo "${repos[$((choice-1))]}" | awk '{print $2}')

        if [[ "$status" == "enabled" ]]; then
            echo "Disabling repo: $repo_id"
            dnf config-manager --set-disabled "$repo_id"
        else
            echo "Enabling repo: $repo_id"
            dnf config-manager --set-enabled "$repo_id"
        fi
    else
        echo "Invalid choice: $choice"
    fi
done






chmod +x dnf-repo-manager.sh


./dnf-repo-manager.sh


dnf repolist --all



