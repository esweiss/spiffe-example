#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export GO111MODULE=on

(cd src/web-server && GOOS=linux go build -v -o $DIR/docker/web/web-server)
(cd src/echo-server && GOOS=linux go build -v -o $DIR/docker/echo/echo-server)
(cd src/spiffe-envoy-agent && GOOS=linux go build -v -o $DIR/docker/envoy-base/spiffe-envoy-agent)
(cd src/layer7proxy && GOOS=linux go build -v -o $DIR/docker/layer7proxy/layer7proxy)
(cd src/decode-jwt && go build -v -o $DIR/decode-jwt)

docker build docker/spire-base -t spire-base
docker build docker/envoy-base -t envoy-base
docker-compose -f docker-compose.yml build
