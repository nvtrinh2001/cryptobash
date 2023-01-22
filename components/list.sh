#!/bin/bash

########## FUNCTIONS ##########
list-submenu() {
    echo -ne "
$(blueprint 'LISTING MENU')
$(greenprint '1)') list top cryptocurrencies
$(magentaprint '2)') go back to MAIN MENU
$(redprint '0)') exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        list 
        list-submenu
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

function list() {
    echo -ne "\nInput a fiat currency (default: USD):   "
    read -r FIAT
    [[ -z $FIAT ]] && FIAT='USD' && echo -e "Using default value: USD"

    echo -ne "\nInput the number of top cryptocurrencies (default: 10):  "
    read -r TOP
    [[ -z $TOP ]] && TOP=10 && echo -e "Using default value: top 10\n"
  
    FIATUC=${FIAT^^} 
    CONVERT="?convert=${FIATUC}"

    LIMIT="&limit=${TOP}"
    if [ $TOP -gt $TOPDEFAULT ]; then
        echo -ne "\nbe patient ..."
    fi
        
    curl -H "X-CMC_PRO_API_KEY: $COINMARKETCAP_API_KEY" -H "Accept: application/json" -s "${DATAURL}listings/latest${CONVERT}${LIMIT}&start=1" >"${JSONFILE}"
    if [ $TOP -gt $TOPDEFAULT ]; then
        echo -e -n "\b\b\b\b\b\b\b\b\b\b\b\b\b\b              \b\b\b\b\b\b\b\b\b\b\b\b\b\b" # erase "be patient ..."
    fi
    errorstatus=$(jq <"${JSONFILE}" "[.status.error_code][]" 2>/dev/null)
        
    if [ "$errorstatus" != "0" ]; then
        echo "${0##*/}: ${red}Error: The https://coinmarketcap.com/ API returned error code \"$errorstatus\". Aborting.${reset}"
    fi

    ii=0
    morelines="true"
    echo -e -n "be patient ..."
    table=$(while [ ${morelines} == "true" ]; do
        ret=$(jq <"${JSONFILE}" "[.data[$ii]][]")
        if [ "$ret" == "null" ]; then
            morelines="false"
            ii=$((ii - 1))
        else
            if [ $ii -eq 0 ]; then
                printHeader
            fi
            process "$ret"
            ii=$((ii + 1))
        fi
    done)
    echo -e -n "\b\b\b\b\b\b\b\b\b\b\b\b\b\b              \b\b\b\b\b\b\b\b\b\b\b\b\b\b" # erase "be patient ..."
    echo "$table" | tr -s "\t" " " | tr -s " " | column -t |
        sed -e "s/\(\+[0-9]*\.[0-9]*%\)/${green}\1${reset}/g" \
            -e "s/\(\-[0-9]*\.[0-9]*%\)/${red}\1${reset}/g" \
            -e "s/\(\+[0-9]*\,[0-9]*%\)/${green}\1${reset}/g" \
            -e "s/\(\-[0-9]*\,[0-9]*%\)/${red}\1${reset}/g"
} 


