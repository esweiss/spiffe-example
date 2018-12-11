#!/bin/bash

set -e

bb=$(tput bold)
nn=$(tput sgr0)

# Start up the web server
echo "${bb}Starting web server...${nn}"
docker-compose exec -d web web-server -log /tmp/web-server.log

# Start up the echo server
echo "${bb}Starting echo server...${nn}"
docker-compose exec -d echo echo-server -log /tmp/echo-server.log

# Start up the layer7proxy server
echo "${bb}Starting layer7 proxy...${nn}"
docker-compose exec -d layer7proxy layer7proxy -to echo:8002
