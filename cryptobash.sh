#!/bin/bash

# source components
source ./components/help.sh
source ./components/helper.sh
source ./components/graph.sh
source ./components/search.sh
source ./components/list.sh
source ./components/dependencies.sh

# Define the COINMARKETCAP API key
COINMARKETCAP_API_KEY=12e76001-8ae7-4e49-8d38-40b20bbe6846
cli=cryptobash

mainmenu() {
    echo -ne "
$(magentaprint 'MAIN MENU')
$(greenprint '1)') list 
$(blueprint '2)') search 
$(yellowprint '3)') graph 
$(magentaprint '4)') predict
$(cyanprint '5)') help
$(redprint '0)') exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        list-submenu
        mainmenu
        ;;
    2)
        search-submenu
        mainmenu
        ;;
    3)
        graph-submenu
        mainmenu
        ;;
    4)
        predict
        mainmenu
        ;;
    5)
        help
        mainmenu
        ;;
    0)
        fn_bye
        ;;
    *)
        fn_fail
        help
        ;;
    esac
}

mainmenu
