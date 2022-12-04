#!/bin/bash

# install gnuplot
# wget -O gnuplot.tar.gz https://sourceforge.net/projects/gnuplot/files/gnuplot-5.4.5.tar.gz/download
# tar -xf gnuplot.tar.gz
# cd gnuplot-5.4.5
# ./configure
# make
# make check
# make install
#
# install jq
if [[ "$(awk -F= '$1 == "ID_LIKE" { print $2 }' /etc/os-release)" == "debian" ]]; then
  sudo apt install jq
  sudo apt install curl
fi

# install curl

graph() {
  # get name from user
  echo 'Input a cryptocurrency: '
  read CRYPTO_NAME

  # query data
  curl -X 'GET' 'https://api.coingecko.com/api/v3/coins/'$CRYPTO_NAME'/market_chart?vs_currency=usd&days=7&interval=hourly' -H 'accept: application/json' > '/tmp/cryptobash.json'

  # modify data
  rm './data/graph-data.dat'

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
