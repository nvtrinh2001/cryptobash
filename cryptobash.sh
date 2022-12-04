#!/bin/bash

# source components
source ./components/help.sh
source ./components/menu.sh
source ./components/graph.sh

# Define the COINMARKETCAP API key
COINMARKETCAP_API_KEY=12e76001-8ae7-4e49-8d38-40b20bbe6846

# Methods
sub-submenu() {
    echo -ne "
$(yellowprint 'SUB-SUBMENU')
$(greenprint '1)') GOOD MORNING
$(greenprint '2)') GOOD AFTERNOON
$(blueprint '3)') Go Back to SUBMENU
$(magentaprint '4)') Go Back to MAIN MENU
$(redprint '0)') Exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        fn_goodmorning
        sub-submenu
        ;;
    2)
        fn_goodafternoon
        sub-submenu
        ;;
    3)
        submenu
        ;;
    4)
        mainmenu
        ;;
    0)
        fn_bye
        ;;
    *)
        fn_fail
        ;;
    esac
}

submenu() {
    echo -ne "
$(blueprint 'CMD1 SUBMENU')
$(greenprint '1)') SUBCMD1
$(magentaprint '2)') Go Back to Main Menu
$(redprint '0)') Exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        sub-submenu
        submenu
        ;;
    2)
        mainmenu
        ;;
    0)
        fn_bye
        ;;
    *)
        fn_fail
        ;;
    esac
}

mainmenu() {
    echo -ne "
$(magentaprint 'MAIN MENU')
$(greenprint '1)') Discover
$(redprint '0)') Exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        submenu
        mainmenu
        ;;
    0)
        fn_bye
        ;;
    *)
        fn_fail
        ;;
    esac
}

mainmenu
