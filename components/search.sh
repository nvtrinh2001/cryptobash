#!/bin/bash

########## FUNCTIONS ##########
search-submenu() {
    echo -ne "
$(blueprint 'SEARCH MENU')
$(greenprint '1)') search for specific cryptocurrencies
$(magentaprint '2)') go back to MAIN MENU
$(redprint '0)') exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        search
        search-submenu
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

function search()
{
    echo -ne "\nInput (a) cryptocurrency name(s):  "
    read -r CCNAMESLIST
    while [[ -z $CCNAMESLIST ]]; do
      echo "A name is required. Try again."
      echo -ne "\nInput (a) cryptocurrency name(s):  "
      read -r CCNAMESLIST
    done

    echo -ne "\nInput a fiat currency (default: USD):   "
    read -r FIAT
    [[ -z $FIAT ]] && FIAT='USD' && echo -e "Using default value: USD"

    FIATUC=${FIAT^^} 
    CONVERT="?convert=${FIATUC}"
    useccnameslist="false"
    
    IFS=', ' read -r -a CCNAMESARRAY <<<"${CCNAMESLIST,,}" 
    useccnameslist="true"
    
    if [ "$useccnameslist" == "true" ]; then
        LIMIT=""
        TOP=0
        echo -e "[\n" >"${JSONFILE}"
        isfirst="true"
        for name in "${CCNAMESARRAY[@]}"; do
            curl -H "X-CMC_PRO_API_KEY: $COINMARKETCAP_API_KEY" -H "Accept: application/json" -s "${DATAURL}quotes/latest${CONVERT}&slug=${name}" >"${JSONFILE}.part"
            errorstatus=$(jq <"${JSONFILE}.part" "[.status.error_code][]" 2>/dev/null)
            if [ "$errorstatus" != "0" ]; then
                echo "${0##*/}: ${red}Error: The https://coinmarketcap.com/ API returned error code \"$errorstatus\". Aborting.${reset}"
            fi

            key=$(jq <"${JSONFILE}.part" "[.data][] | keys" | jq .[]) 
            entry=$(jq <"${JSONFILE}.part" "[.data][].$key")
            if [ "$isfirst" == "true" ]; then
                isfirst="false"
            else
                echo -e ",\n" >>"${JSONFILE}"
            fi
                echo -e "\n${entry}\n" >>"${JSONFILE}"
        done
        echo -e "\n]\n" >>"${JSONFILE}"
        rm -f "${JSONFILE}.part"
    else
        echo "Please enter an input."
    fi

    ii=0
    morelines="true"
    echo -e -n "\nbe patient ..."
    table=$(while [ ${morelines} == "true" ]; do
        if [ "$useccnameslist" == "true" ]; then
            ret=$(jq <"${JSONFILE}" ".[$ii]")
        else
            ret=$(jq <"${JSONFILE}" "[.data[$ii]][]")
        fi
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


