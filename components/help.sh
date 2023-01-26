#!/bin/bash

help() {
	while read -r line; do
		printf "%s\n" "$line"
	done <<-EOF
	
	Usage:
	  	list        list a number of cryptocurrencies 
	  	search      search for a specific cryptocurrencies
	  	graph       display a graph using received data
	  	predict     make a prediction based on current data
	  	update      fetch update from github
	
	Options:
	  	-v          print version number
	  	-h          show helptext

EOF
}
