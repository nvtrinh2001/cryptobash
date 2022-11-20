#!/bin/bash

# Enable the execution permission for components
chmod +x './components/api-handler.sh'
chmod +x './components/help.sh'

# Get the COINMARKETCAP API key
./components/api-handler.sh

#
./components/help.sh

