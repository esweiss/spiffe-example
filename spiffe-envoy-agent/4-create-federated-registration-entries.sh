#/bin/bash

set -e

bb=$(tput bold)
nn=$(tput sgr0)

# Create a web server workload registration entry that federates with trustdomain2.org
echo "${bb}Creating registration entry for the web server (with federation)...${nn}"
docker-compose exec trustdomain1-server spire-server entry create \
	-parentID spiffe://trustdomain1.org/spire/agent/x509pop/1c543a5e7b1a6360ed675a265802ee48e94cc512 \
	-spiffeID spiffe://trustdomain1.org/web-server \
	-selector unix:user:spiffe-envoy-agent \
	-federatesWith spiffe://trustdomain2.org

# Create an echo server workload registration entry that federates with trustdomain1.org
echo "${bb}Creating registration entry for the echo server (with federation)...${nn}"
docker-compose exec trustdomain2-server spire-server entry create \
	-parentID spiffe://trustdomain2.org/spire/agent/x509pop/f9528ed77ac34b3cfaad55513c98d53701440336 \
	-spiffeID spiffe://trustdomain2.org/echo-server \
	-selector unix:user:spiffe-envoy-agent \
	-federatesWith spiffe://trustdomain1.org
