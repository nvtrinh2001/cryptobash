#!/bin/bash

predict-submenu() {
    echo -ne "
$(blueprint 'PRICE PREDICTION MENU')
$(greenprint '1)') forcast price of a cryptocurrency 
$(magentaprint '2)') go back to MAIN MENU
$(redprint '0)') exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        predict
        predict-submenu
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

predict() {
  echo -ne "\nInput a cryptocurrency:  "
  read -r CRYPTO_NAME
  while [[ -z $CRYPTO_NAME ]]; do
    echo "A name is required. Try again."
    echo -ne "\nInput a cryptocurrency:  "
    read -r CRYPTO_NAME
  done

  echo -ne "\nInput a number of hours (default: 1):  "
  read -r HOURS
  [[ -z $HOURS ]] && HOURS=1 && echo -e "Using default value: 1 hour ahead"

  jq '.[] | select(.id=="'$CRYPTO_NAME'")' ./components/data-service/src/data/cryptoList.json > /var/tmp/predict
  COIN_ID=$(jq '.symbol' /var/tmp/predict)
  echo COIN_ID=${COIN_ID^^} > ./components/predict/.env
  echo HOURS=$HOURS >> ./components/predict/.env

  echo -ne "be patient ..."
  python3 ./components/predict/predictive-model.py > /dev/null 2> /dev/null
  python3 ./components/predict/main.py > /dev/null 2> /dev/null

  # display using gnuplot
  PLOT_STR="plot \"/var/tmp/actual-data.txt\" u 1:2 with lines title 'Actual ${CRYPTO_NAME^} Price', \"/var/tmp/predicted-data.txt\" u 1:2 with lines title 'Predicted ${CRYPTO_NAME^} Price'"

gnuplot --persist <<-EOFMarker
set xdata time
set datafile separator ","
set timefmt "%H:%M:%S %d-%m-%Y"
set format x "%H:%M\n%m-%d"
set ylabel "Price (USD)"
set xlabel "Date"
$PLOT_STR
EOFMarker

echo -e -n "\b\b\b\b\b\b\b\b\b\b\b\b\b\b              \b\b\b\b\b\b\b\b\b\b\b\b\b\b" # erase "be patient ..."
echo -e "\nCompleted! You can now see the prediction graph displayed on your machine."
}

