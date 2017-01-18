#!/bin/bash

# Stop on error
set -e

if [ $# -eq 0 ]
  then
    # expect shiny server compiled in /home/pi/shiny-server
  else
    # build shiny server from source
    # https://github.com/rstudio/shiny-server/wiki/Building-Shiny-Server-from-Source
    cd
    git clone https://github.com/rstudio/shiny-server.git
    cd shiny-server; 
    DIR=`pwd`; 
    PATH=$DIR/bin:$PATH
    mkdir tmp; 
    cd tmp; 
    PYTHON=`which python`
    sudo cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DPYTHON="$PYTHON" ../
    make; 
    mkdir ../build
    (cd .. && ./bin/npm --python="$PYTHON" rebuild)
    (cd .. && ./bin/node ./ext/node/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js --python="$PYTHON" rebuild)
fi

# build docker image
docker build -t oydeu/oyd-shiny_armhf .
