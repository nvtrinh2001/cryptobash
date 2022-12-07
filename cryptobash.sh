#!/bin/bash

# Enable the execution permission for components
chmod +x './components/help.sh'
chmod +x './components/list.sh'

# Define the COINMARKETCAP API key
COINMARKETCAP_API_KEY=12e76001-8ae7-4e49-8d38-40b20bbe6846

# Methods
# Pass the constants along with the command if needed. 
# For example: 
# ./components/search.sh $COINMARKETCAP_API_KEY
./components/help.sh
./components/list.sh


