#!/bin/bash


# DEFINE GIANG's API_KEY  
COINMARKETCAP_API_KEY=d11cf38c-97b0-4a07-87e9-4d6c22ed264a

#debug if not install
if [[ "$(awk -F= '$1 == "ID_LIKE" { print $2 }' /etc/os-release)" == "debian" ]]; then
sudo apt install jq
sudo apt install curl
fi

########## CONSTANTS ##########

red=$(tput setaf 1) # Error
green=$(tput setaf 2) # OK
yellow=$(tput setaf 3) # Warning
bold=$(tput bold) # bold
rev=$(tput rev) # reverse
reset=$(tput sgr0) # reset, clearing, back to default


########## VARIABLES ##########
URLPREFIX="https://"
URLBASE="pro-api.coinmarketcap.com/"
URLPOSTFIX="v1/cryptocurrency/"
DATAURL=${URLPREFIX}${URLBASE}${URLPOSTFIX}
TOPDEFAULT=100   # default
TOP=$TOPDEFAULT # init
JSONFILE="/tmp/${0##*/}.tmp.json"
FIAT="USD"      # default fiat currency
FIATARRAY=(BTC ETH USDT XRP BCH BNB DOT LINK CRO BSV LTC XAU XAG XPT XPD AUD BRL CAD CHF CLP CNY CZK DKK EUR GBP HKD HUF IDR ILS INR JPY KRW MXN MYR NOK NZD PHP PKR PLN RUB SEK SGD THB TRY TWD USD ZAR VND)
VND="false"
MATCHED=0
ALLMATCHED=99 # constant, return code, signifies all entries in CCSYMBOLSLIST have been printed
CCSYMBOLSARRAY=()
CCSYMBOLSLIST=""    # string of crypt currencies seperated by comma (,) without spaces ( ). E.g. btc,eth,ltc

########## FUNCTIONS ##########

# print header
function printHeader() {
    rank="Rank"
    symbol="Symbol"
    name="Name"
    price="$FIATUC"
    market_cap="Market-cap-$FIATUC"
    price_btc="BTC"
    percent_change_24h="24h-Change"
    percent_change_7d="7d-Change"
    a24h_volume="24h-Volume-$FIATUC"
    available_supply="Available-Supply"
    total_supply="Total-Supply"
    max_supply="Max-Supply"
    percent_change_1h="1h-Change"
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%17s\t%17s\t%17s\t%17s\t%17s\n" "$rank" "$symbol" "$name" "$price" "$percent_change_1h" "$percent_change_24h" "$percent_change_7d" "$a24h_volume" "$available_supply" "$total_supply" "$max_supply" "$market_cap"
}
#setSeperator
function setSeperator() {
    if [ "$(printf '%3.1f' 1.3 2>/dev/null)" == "1.3" ]; then
        seperator="."
    elif [ "$(printf '%3.1f' 1,3 2>/dev/null)" == "1,3" ]; then
        seperator=","
    else
        LC_NUMERIC="en_US.UTF-8"
        seperator="."
    fi
}
#process
function process() {
    symbol=$(echo "$1" | jq ".symbol")
    symbol="${symbol%\"}"
    symbol="${symbol#\"}"

    if [ "$useccsymbolslist" == "true" ]; then
        match="false"
        for element in "${CCSYMBOLSARRAY[@]}"; do
            if [ "$element" == "$symbol" ]; then
                match="true"
                ((MATCHED++))
                break
            fi
        done
        if [ "$match" == "false" ]; then
            return 0
        fi
    fi

    rank=$(echo "$1" | jq ".cmc_rank")

    name=$(echo "$1" | jq ".name")

    name="${name%\"}" # remove trailing quote

    name="${name#\"}" # remove leading quote

    name=$(tr "[:blank:]" " " <<<$name | tr -s " " | tr " " "-")

    price=$(echo "$1" | jq ".quote.$FIATUC.price")

    [ $seperator == "," ] && price=${price//./,} # replace all dots
    price_btc="---"

    [ $seperator == "," ] && price_btc=${price_btc//./,} # replace all dots
    percent_change_24h=$(echo "$1" | jq ".quote.$FIATUC.percent_change_24h")

    [ $seperator == "," ] && percent_change_24h=${percent_change_24h//./,} # replace all dots
    percent_change_7d=$(echo "$1" | jq ".quote.$FIATUC.percent_change_7d")

    [ $seperator == "," ] && percent_change_7d=${percent_change_7d//./,} # replace all dots
    market_cap=$(echo "$1" | jq ".quote.$FIATUC.market_cap")

    [ $seperator == "," ] && market_cap=${market_cap//./,} # replace all dots
    a24h_volume=$(echo "$1" | jq ".quote.$FIATUC.volume_24h")

    [ $seperator == "," ] && a24h_volume=${a24h_volume//./,} # replace all dots
    
    available_supply=$(echo "$1" | jq ".circulating_supply") # available_supply

    [ $seperator == "," ] && available_supply=${available_supply//./,} # replace all dots

    total_supply=$(echo "$1" | jq ".total_supply")

    [ $seperator == "," ] && total_supply=${total_supply//./,} # replace all dots

    max_supply=$(echo "$1" | jq ".max_supply")
    [ $seperator == "," ] && max_supply=${max_supply//./,} # replace all dots

    percent_change_1h=$(echo "$1" | jq ".quote.$FIATUC.percent_change_1h")
    [ $seperator == "," ] && percent_change_1h=${percent_change_1h//./,} # replace all dots
    printf "%d\t%s\t%s\t%'1.8f\t%+6.1f%%\t%+6.1f%%\t%+6.1f%%\t%'17.f\t%'17.f\t%'17.f\t%'17.f\t%'17.f\n" "$rank" "$symbol" "$name" "$price" "$percent_change_1h" "$percent_change_24h" "$percent_change_7d" "$a24h_volume" "$available_supply" "$total_supply" "$max_supply" "$market_cap" 2>/dev/null
    if [ "$useccsymbolslist" == "true" ]; then
        if [ "$MATCHED" -ge ${#CCSYMBOLSARRAY[@]} ]; then
            return "$ALLMATCHED" # stop scanning, all symbols have been matched
        fi
    fi
    return 1
}

function listbysymbols(){
    FIATUC=${FIAT^^} # uppercase
    fiatvalid="false"
    CONVERT="?convert=${FIATUC}"
    for item in "${FIATARRAY[@]}"; do
        [[ "$FIATUC" == "$item" ]] && fiatvalid="true"
    done
    # if [ "$VND" == "true" ]; then
    #     FIAT="VND"
    #     FIATUC=${FIAT^^} # uppercase
    #     FIATLC=${FIAT,,} # lowercase
    # fi
    echo 'Input a list of symbols cryptocurrency: '
    read CCSYMBOLSLIST
    useccsymbolslist="false"
    if [ "$CCSYMBOLSLIST" == "" ]; then
        echo "${0##*/}: ${yellow}${bold}List of symbols is empty, ignoring it.${reset}"
    else
        IFS=', ' read -r -a CCSYMBOLSARRAY <<<"${CCSYMBOLSLIST^^}" # will even work on strings like "btc,eth ltc xmr, bch"
        useccsymbolslist="true"
    fi

    LIMIT="&limit=${TOP}"
    if [ $TOP -gt $TOPDEFAULT ]; then
        echo -n "be patient ..."
    fi
    curl -H "X-CMC_PRO_API_KEY: $COINMARKETCAP_API_KEY" -H "Accept: application/json" -s "${DATAURL}listings/latest${CONVERT}${LIMIT}&start=1" >"${JSONFILE}"
    if [ $TOP -gt $TOPDEFAULT ]; then
        echo -e -n "\b\b\b\b\b\b\b\b\b\b\b\b\b\b              \b\b\b\b\b\b\b\b\b\b\b\b\b\b" # erase "be patient ..."
    fi
    errorstatus=$(jq <"${JSONFILE}" "[.status.error_code][]" 2>/dev/null)
        
    if [ "$errorstatus" != "0" ]; then
        echo "${0##*/}: ${red}Error: The https://coinmarketcap.com/ API returned error code \"$errorstatus\". Aborting.${reset}"
    fi
    setSeperator
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
            if [ $? -eq $ALLMATCHED ]; then
                morelines="false"
            fi
            ii=$((ii + 1))
        fi
    done)
    echo -e -n "\b\b\b\b\b\b\b\b\b\b\b\b\b\b              \b\b\b\b\b\b\b\b\b\b\b\b\b\b" # erase "be patient ..."
    echo "$table" | tr -s "\t" " " | tr -s " " | column -t $COLUMNOPTIONS |
        sed -e "s/\(\+[0-9]*\.[0-9]*%\)/${green}\1${reset}/g" \
            -e "s/\(\-[0-9]*\.[0-9]*%\)/${red}\1${reset}/g" \
            -e "s/\(\+[0-9]*\,[0-9]*%\)/${green}\1${reset}/g" \
            -e "s/\(\-[0-9]*\,[0-9]*%\)/${red}\1${reset}/g"
}
##call the function to test
##listbysymbols
