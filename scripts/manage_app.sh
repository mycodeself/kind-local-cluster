# Manage the given app
# Usage: bash scripts/manage_app.sh [install|upgrade|delete] [app name]
#!/bin/bash

set -o errexit

if [ "$#" -ne 2 ]; then
    echo "Invalid arguments, usage:"
    echo "./$0 [install|upgrade|delete] [app name]"
    exit 1
fi

CONFIG_FILE="config.yaml"
ACTION=$1
APP=$2

case $ACTION in
    install|upgrade|delete) ;;
    *) 
      echo "argument $ACTION not valid, expected one of: install, upgrade or delete"
      exit 1
    ;;
esac

if [ $(yq -r ".apps | has(\"$APP\")" $CONFIG_FILE) == "false" ]; then
    echo "$APP not found in apps in config file"
    exit 1
fi

method=$(yq -r ".apps.\"$APP\".method" $CONFIG_FILE)
namespace=$(yq -r ".apps.\"$APP\".namespace | select (.!=null)" $CONFIG_FILE)
extra_args=$(yq -r ".apps.\"$APP\".extraArgs | select (.!=null)" $CONFIG_FILE)
ns_arg="--namespace $namespace"

echo "Performing action $ACTION in app $namespace/$APP with $method ..."

case $method in
  helm)
    case $ACTION in
      install) 
        helm install -f apps/$APP/values.yaml $APP apps/$APP $ns_arg $extra_args
      ;;      
      upgrade)
        helm upgrade -f apps/$APP/values.yaml $APP apps/$APP $ns_arg $extra_args
      ;;
      delete)
        helm uninstall $APP $ns_arg
      ;;
    esac
  ;;
  kubectl)
    case $ACTION in
      install|upgrade) 
        kubectl apply -f apps/$APP --recursive $ns_arg
      ;;      
      delete)
        kubectl delete -f apps/$APP --recursive $ns_arg
      ;;
    esac  
    
  ;;
  *)
    echo "Installation method not supported, review config"
    exit 1
  ;;
esac