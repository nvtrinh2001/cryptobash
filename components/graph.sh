#!/bin/bash

DEFAULTDAYS=7
DEFAULTFIAT=usd

graph() {

  if [[ -z $2 ]]; then
    echo "Expect at least one crypto currency as an argument. Try again!"
    exit 1
  fi

  CRYPTO_NAME=$3
  shift
  shift

  # Load the user defined parameters
  while [[ $# > 1 ]]
  do
    case "$2" in

      -d|--days)
        DAYS="$3"
        shift
      ;;

      -f|--fiat)
        FIAT="$3"
        shift
      ;;
    
      --help|*)
        echo "Usage:"
        echo "    --valueA \"value\""
        echo "    --valueB \"value\""
        echo "    --help"
        exit 1
      ;;
    esac
    shift
  done

  if [[ -z $DAYS ]]; then
    DAYS=$DEFAULTDAYS
  fi
  if [[ -s $FIAT ]]; then
    FIAT=$DEFAULTFIAT
  fi

  # remove old files
  if [[ -e /tmp/cryptobash.json ]]; then
    rm /tmp/cryptobash.json
  fi
  if [[ -e ./data/graph-data.dat ]]; then
    rm ./data/graph-data.dat 
  fi

  # query data
  curl -X 'GET' 'https://api.coingecko.com/api/v3/coins/'$CRYPTO_NAME'/market_chart?vs_currency='$FIAT'&days='$DAYS'&interval=hourly' -H 'accept: application/json' > '/tmp/cryptobash.json' 
  errorstatus=$(jq <"/tmp/cryptobash.json" "[.status.error_code][]" 2>/dev/null)
        
  if [[ "$errorstatus" != "0" ]]; then
    echo '  '
    echo 'API call failed. Check the name of your crypto currency. Make sure the name is listed on CoinGecko.'
    exit 1
  fi

  # modify data

  len=$(jq '.prices | length' /tmp/cryptobash.json)
  for (( i = 0; i < $len; i++ )); do
    raw_timestamp=$(jq ".prices[$i][0]" /tmp/cryptobash.json)
    price=$(jq ".prices[$i][1]" /tmp/cryptobash.json)
    timestamp=$(date -d @$(expr $raw_timestamp / 1000) "+%Y-%m-%d %H:%M")
    echo "$timestamp,$price" >> './data/graph-data.dat'
  done

  # display using gnuplot
gnuplot --persist <<-EOFMarker
set xdata time
set datafile separator ","
set timefmt "%Y-%m-%d %H:%M"
set format x "%m-%d\n%Y"
plot './data/graph-data.dat' u 1:2 with lines title 'Price'
EOFMarker
}
