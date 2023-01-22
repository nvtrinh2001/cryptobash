#!/bin/bash

graph-submenu() {
    echo -ne "
$(blueprint 'GRAPH MENU')
$(greenprint '1)') draw a graph
$(magentaprint '2)') go back to MAIN MENU
$(redprint '0)') exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        graph
        graph-submenu
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

graph() {
  echo -ne "\nInput (a) cryptocurrency name(s):  "
  read -r CRYPTO_NAME
  while [[ -z $CRYPTO_NAME ]]; do
    echo "A name is required. Try again."
    echo -ne "\nInput (a) cryptocurrency name(s):  "
    read -r CRYPTO_NAME
  done

  echo -ne "\nInput a fiat currency (default: USD):   "
  read -r FIAT
  [[ -z $FIAT ]] && FIAT='usd' && echo -e "Using default value: USD"

  echo -ne "\nInput a number of days (default: 7):  "
  read -r DAYS
  [[ -z $DAYS ]] && DAYS=7 && echo -e "Using default value: 7 days"

  # get name of the crypto
  IFS=', ' read -r -a crypto_array <<< "$CRYPTO_NAME"

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
    echo -e "\nConnecting to mongodb ...\n"
  
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
        echo -e "\nAPI call failed. Check the name of your crypto currency. Make sure the name is listed on CoinGecko."
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
set ylabel "Price ($FIAT)"
set xlabel "Date"
$PLOT_STR
EOFMarker

echo -e -n "\b\b\b\b\b\b\b\b\b\b\b\b\b\b              \b\b\b\b\b\b\b\b\b\b\b\b\b\b" # erase "be patient ..."
echo -e "\nCompleted! You can now see the graph displayed on your machine."
}

