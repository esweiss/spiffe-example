#!/bin/bash

set -e

bb=$(tput bold)
nn=$(tput sgr0)

# Start up the trustdomain1.org SPIRE server and sleep a little bit to give it 
# time to come up.
echo "${bb}Starting trustdomain1.org SPIRE server...${nn}"
docker-compose exec -d trustdomain1-server spire-server run
sleep .5

# Start up the web server SPIRE agent, first copying over the spire server bundle
# to bootstrap agent to server trust. Alternatively, an upstream CA could be
# configured on the SPIRE server.
echo "${bb}Starting web server SPIRE agent...${nn}"
docker-compose exec -T trustdomain1-server spire-server bundle show |
	docker-compose exec -T web tee conf/agent/bootstrap.crt > /dev/null
docker-compose exec -d web spire-agent run

# Start up the web SPIFFE Envoy agent
echo "${bb}Starting web server SPIFFE Envoy agent...${nn}"
docker-compose exec -d web supervise /etc/service/spiffe-envoy-agent

# Start up the trustdomain2.org SPIRE server and sleep a little bit to give it 
# time to come up.
echo "${bb}Starting trustdomain2.org SPIRE server...${nn}"
docker-compose exec -d trustdomain2-server spire-server run
sleep .5

# Start up the echo server SPIRE agent, first copying over the spire server bundle
# to bootstrap agent to server trust. Alternatively, an upstream CA could be
# configured on the SPIRE server.
echo "${bb}Starting echo server SPIRE agent...${nn}"
docker-compose exec -T trustdomain2-server spire-server bundle show |
	docker-compose exec -T echo tee conf/agent/bootstrap.crt > /dev/null
docker-compose exec -d echo spire-agent run

# Start up the echo server SPIFFE Envoy agent
echo "${bb}Starting echo server SPIFFE Envoy agent...${nn}"
docker-compose exec -d echo supervise /etc/service/spiffe-envoy-agent
