#!/bin/bash
########## CONSTANTS ##########

red=$(tput setaf 1) 
green=$(tput setaf 2) 
yellow=$(tput setaf 3) 
bold=$(tput bold) 
rev=$(tput rev) 
reset=$(tput sgr0) 

########## VARIABLES ##########
URLPREFIX="https://"
URLBASE="pro-api.coinmarketcap.com/"
URLPOSTFIX="v1/cryptocurrency/"
DATAURL=${URLPREFIX}${URLBASE}${URLPOSTFIX}
JSONFILE="/tmp/${0##*/}.tmp.json"
TOPDEFAULT=10   
TOP=$TOPDEFAULT 
FIAT="USD"      
CCNAMESARRAY=()
CCNAMESLIST=""

########## FUNCTIONS ##########

function printHeader() {
    rank="Rank"
    symbol="Symbol"
    name="Name"
    price="$FIATUC"
    market_cap="Market-cap-$FIATUC"
    price_btc="BTC"
    percent_change_24h="24h-Change"
    percent_change_7d="7d-Change"
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%17s\n" "$rank" "$symbol" "$name" "$price" "$percent_change_24h" "$percent_change_7d" "$market_cap"
}

function process() {
    symbol=$(echo "$1" | jq ".symbol")
    symbol="${symbol%\"}"
    symbol="${symbol#\"}"

    rank=$(echo "$1" | jq ".cmc_rank")

    name=$(echo "$1" | jq ".name")
    name="${name%\"}" 
    name="${name#\"}" 
    name=$(tr "[:blank:]" " " <<<$name | tr -s " " | tr " " "-")

    price=$(echo "$1" | jq ".quote.$FIATUC.price")
    price_btc="---"

    percent_change_24h=$(echo "$1" | jq ".quote.$FIATUC.percent_change_24h")
    percent_change_7d=$(echo "$1" | jq ".quote.$FIATUC.percent_change_7d")

    market_cap=$(echo "$1" | jq ".quote.$FIATUC.market_cap")
    printf "%d\t%s\t%s\t%'1.8f\t%+6.1f%%\t%+6.1f%%\t%'17.f\n" "$rank" "$symbol" "$name" "$price" "$percent_change_24h" "$percent_change_7d" "$market_cap" 2>/dev/null

    return 1
}

function search()
{
    FIATUC=${FIAT^^} 
    CONVERT="?convert=${FIATUC}"
    echo 'Input a cryptocurrency: '
    read CCNAMESLIST
    echo 'Input a fiat: '
    read FIAT
    FIATUC=${FIAT^^} 
    CONVERT="?convert=${FIATUC}"
    useccnameslist="false"
    if [ "$CCNAMESLIST" == "" ]; then
        useccnameslist="false"
    else
        IFS=', ' read -r -a CCNAMESARRAY <<<"${CCNAMESLIST,,}" 
        useccnameslist="true"
    fi
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
    echo -e -n "be patient ..."
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


