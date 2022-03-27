# Manage all the apps declared in the config file
# Usage: bash scripts/manage_all_apps.sh [install|upgrade|delete]
#!/bin/bash

set -o errexit

if [ "$#" -ne 1 ]; then
    echo "Invalid arguments, usage:"
    echo "./$0 [install|upgrade|delete]"
    exit 1
fi

CONFIG_FILE="config.yaml"
ACTION=$1

case $ACTION in
    install|upgrade|delete) ;;
    *) 
      echo "argument $ACTION not valid, expected one of: install, upgrade or delete"
      exit 1
    ;;
esac

excluded_apps=($(yq -r '.excludedApps[]' $CONFIG_FILE))

# load all app projects from config file excluding the excludedApps
while IFS= read -r value; do    
    if [[ ! " ${excluded_apps[*]} " =~ " ${value} " ]]; then
        ALL_APPS+=($value)
    fi    
done < <(yq -r '.apps | keys[]' $CONFIG_FILE)

for app in ${ALL_APPS[*]}; do
    bash scripts/manage_app.sh $ACTION $app
done