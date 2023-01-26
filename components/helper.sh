#!/usr/bin/env bash

### Colors ##
ESC=$(printf '\033') RESET="${ESC}[0m" BLACK="${ESC}[30m" RED="${ESC}[31m"
GREEN="${ESC}[32m" YELLOW="${ESC}[33m" BLUE="${ESC}[34m" MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m" WHITE="${ESC}[37m" DEFAULT="${ESC}[39m"

### Color Functions ##

greenprint() { printf "${GREEN}%s${RESET}\n" "$1"; }
blueprint() { printf "${BLUE}%s${RESET}\n" "$1"; }
redprint() { printf "${RED}%s${RESET}\n" "$1"; }
yellowprint() { printf "${YELLOW}%s${RESET}\n" "$1"; }
magentaprint() { printf "${MAGENTA}%s${RESET}\n" "$1"; }
cyanprint() { printf "${CYAN}%s${RESET}\n" "$1"; }
fn_goodafternoon() { echo; echo "Good afternoon."; }
fn_goodmorning() { echo; echo "Good morning."; }
fn_bye() { echo "Bye bye."; exit 0; }
fn_fail() { echo "Wrong option." exit 1; }

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

########## HELPER FUNCTIONS ##########

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

