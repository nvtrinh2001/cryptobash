#!/bin/bash

# install gnuplot
if [[ ! -e /usr/local/bin/gnuplot ]]; then
  wget -O $HOME/gnuplot.tar.gz https://sourceforge.net/projects/gnuplot/files/gnuplot-5.4.5.tar.gz/download
  tar -xf $HOME/gnuplot.tar.gz
  cd $HOME/gnuplot-5.4.5
  ./configure
  make
  make check
  make install
fi

# install jq, curl
if [[ "$(awk -F= '$1 == "ID_LIKE" { print $2 }' /etc/os-release)" == "debian" ]]; then
  if [[ ! -e /bin/jq ]]; then 
    sudo apt install jq
  fi
  if [[ ! -e /bin/curl ]]; then
    sudo apt install curl
  fi
fi

