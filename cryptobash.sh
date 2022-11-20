#!/bin/bash

if [$COINMARKETCAP_API_KEY == ""]; then
  command python3 -m webbrowser -t https://pro.coinmarketcap.com/account
  sleep 5
  echo "Go to COINMARKETCAP website to get the API key!"
fi
while [$COINMARKETCAP_API_KEY == ""]; do 
  echo "Input your API key below: " 
  read COINMARKETCAP_API_KEY
  echo $COINMARKETCAP_API_KEY
done
read INPUT
# curl -H "X-CMC_PRO_API_KEY: $COINMARKETCAP_API_KEY" -H "Accept: application/json" -d "start=1&limit=9&convert=USD" -G https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest
curl -H "X-CMC_PRO_API_KEY: $COINMARKETCAP_API_KEY" -H "Accept: application/json" -d "convert=USD&slug=$INPUT" -G https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest
