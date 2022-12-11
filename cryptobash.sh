#!/bin/bash

# source components
source ./components/help.sh
source ./components/menu.sh
source ./components/graph.sh
source ./components/list.sh
source ./components/search.sh
source ./components/display.sh
source ./components/dependencies.sh

# Define the COINMARKETCAP API key
COINMARKETCAP_API_KEY=12e76001-8ae7-4e49-8d38-40b20bbe6846

if [[ -z $1 ]]; then
  help 
else
  case "$1" in
    list|l) 
      display "$@"
    ;;
    search|s) 
      search "$@"
    ;;
    graph|g) 
      graph "$@"
    ;;
    help|h) 
      help
    ;;
    *) 
      echo "Option not found! Try again.\n"
      help 
    ;;
  esac
fi
