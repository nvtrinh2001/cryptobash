#!/bin/bash

cli=cryptobash

help() {
	while read -r line; do
		printf "%s\n" "$line"
	done <<-EOF
	
	Usage:
	  	$cli list [OPTIONS]		list a number of cryptocurrencies (Default: 10)
	  	$cli search [OPTIONS]		search for a specific cryptocurrencies
	  	$cli graph [OPTIONS]		display a graph using received data
	  	$cli predict [OPTIONS]		make a prediction based on current data
	  	$cli clear			delete all data in data folder
	  	$cli update			fetch update from github
	
	Options:
	  	-v print version number
	  	-h show helptext

EOF
}
