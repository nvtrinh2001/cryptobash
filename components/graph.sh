#!/bin/bash

DEFAULTDAYS=7
DEFAULTFIAT=usd

graph() {

  # no argument
  if [[ -z $2 ]]; then
    echo "Expect at least one crypto currency as an argument. Try again!"
    exit 1
  fi
  # get name of the crypto
  CRYPTO_NAME=$3
  shift
  shift
  IFS=',' read -r -a crypto_array <<< "$CRYPTO_NAME"

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
        echo "    Display a price graph of a given crypto currency in an amount of time"
        echo "    cryptobash graph -n|--name [CRYPTO_NAME1,CRYPTO_NAME2,...] [OPTIONS]"
        echo "    "
        echo "    -d|--days: specify number of days"
        echo "    -f|--fiat: specify a fiat currency. For example: usd, eur, vnd, etc."
        echo "    -h|--help: open this message"
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
  if compgen -G "/tmp/cryptobash*" > /dev/null; then
    rm /tmp/cryptobash*
  fi
  if compgen -G "/tmp/graph-data*" > /dev/null; then
    rm /tmp/graph-data*
  fi

  isInDB=0
  if [[ $DAYS == 7 ]] || [[ $DAYS == 14 ]] || [[ $DAYS == 30 ]]; then
  isInDB=1 
  fi

  # query data
  if [[ $isInDB == 1 ]]; then
    # query data
    echo -e "Connecting to mongodb ...\n"
  
    for index in ${!crypto_array[@]}
    do
      mongoexport --collection=cryptodatas --db=crypto --fields=prices --query='{"crytoId": "'${crypto_array[$index]}'", "numberOfDay": '$DAYS'}' --out=/tmp/cryptobash"$index".json
      [[ -s /tmp/cryptobash"$index".json ]] || isInDB=0
    done
    [[ $isInDB == 1 ]] || echo -e -n "\nCannot find cryptocurrencies in local database!\n"
  fi
  
  if [[ $isInDB == 0 ]]; then
    echo -n -e "\nFetching data using CoinGecko API ..."

    for index in ${!crypto_array[@]}
    do
      curl -X 'GET' -s 'https://api.coingecko.com/api/v3/coins/'${crypto_array[$index]}'/market_chart?vs_currency='$FIAT'&days='$DAYS'&interval=hourly' -H 'accept: application/json' > /tmp/cryptobash"$index".json

      errorstatus=$(grep error /tmp/cryptobash$index.json)
   
      if [[ ! -z "$errorstatus" ]]; then
        echo "\nAPI call failed. Check the name of your crypto currency. Make sure the name is listed on CoinGecko."
        exit 
      fi

    done
  fi
  
  # modify data
  echo -n -e "\nProcessing data, be patient ...\n"
  len=$(jq '.prices | length' /tmp/cryptobash0.json)
  for (( i = 0; i < $len; i++ )); do
    raw_timestamp=$(jq ".prices[$i][0]" /tmp/cryptobash0.json)
    price=$(jq ".prices[$i][1]" /tmp/cryptobash0.json)
    timestamp=$(date -d @$(expr $raw_timestamp / 1000) "+%Y-%m-%d %H:%M")
    echo "$timestamp,$price" >> /tmp/graph-data0.dat
  done
  
  for j in ${!crypto_array[@]}
  do
    if [[ $j != 0 ]]; then
      len=$(jq '.prices | length' /tmp/cryptobash"$j".json)
      for (( i = 0; i < $len; i++ )); do
        price=$(jq ".prices[$i][1]" /tmp/cryptobash"$j".json)
        echo "$price" >> /tmp/graph-data"$j".dat
      done
    fi
  done
  if [[ -e /tmp/graph-data1.dat ]]; then
    paste -d ',' /tmp/graph-data0.dat /tmp/graph-data[1-9]*.dat > /tmp/graph-data.dat
  else
    mv /tmp/graph-data0.dat /tmp/graph-data.dat
  fi

  # display using gnuplot
  field=2
  PLOT_STR="plot \"/tmp/graph-data.dat\" u 1:2 with lines title '${crypto_array[0]} price'"
  for k in ${!crypto_array[@]}
  do
    if (( $k != 0 )); then
      PLOT_STR+=", \"/tmp/graph-data.dat\" u 1:$(expr $field + $k) with lines title '${crypto_array[$k]} price'"
    fi
  done

gnuplot --persist <<-EOFMarker
set xdata time
set datafile separator ","
set timefmt "%Y-%m-%d %H:%M"
set format x "%m-%d\n%Y"
$PLOT_STR
EOFMarker

echo -e -n "\b\b\b\b\b\b\b\b\b\b\b\b\b\b              \b\b\b\b\b\b\b\b\b\b\b\b\b\b" # erase "be patient ..."
echo "Completed! You can now see the graph displayed on your machine."
}


