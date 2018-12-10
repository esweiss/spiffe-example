#/bin/bash

set -e

bb=$(tput bold)
nn=$(tput sgr0)

# Create or update the web server registration entry without any federation
ENTRYID=$(docker-compose exec -T trustdomain1-server spire-server entry show | grep -m1 "Entry ID" | awk '{print $3}')
if [[ -z ${ENTRYID} ]]; then
	echo "${bb}Creating registration entry for the web server (no federation)...${nn}"
	docker-compose exec trustdomain1-server spire-server entry create \
		-parentID spiffe://trustdomain1.org/spire/agent/x509pop/1c543a5e7b1a6360ed675a265802ee48e94cc512 \
		-spiffeID spiffe://trustdomain1.org/web-server \
		-selector unix:user:spiffe-envoy-agent
else
	echo "${bb}Updating registration entry for the web server (no federation)...${nn}"
	docker-compose exec trustdomain1-server spire-server entry update \
		-entryID ${ENTRYID} \
		-parentID spiffe://trustdomain1.org/spire/agent/x509pop/1c543a5e7b1a6360ed675a265802ee48e94cc512 \
		-spiffeID spiffe://trustdomain1.org/web-server \
		-selector unix:user:spiffe-envoy-agent
fi

# Create or update the echo server registration entry without any federation
ENTRYID=$(docker-compose exec -T trustdomain2-server spire-server entry show | grep -m1 "Entry ID" | awk '{print $3}')
if [[ -z ${ENTRYID} ]]; then
	echo "${bb}Creating registration entry for the echo server (no federation)...${nn}"
	docker-compose exec trustdomain2-server spire-server entry create \
		-parentID spiffe://trustdomain2.org/spire/agent/x509pop/f9528ed77ac34b3cfaad55513c98d53701440336 \
		-spiffeID spiffe://trustdomain2.org/echo-server \
		-selector unix:user:spiffe-envoy-agent
else
	echo "${bb}Updating registration entry for the echo server (no federation)...${nn}"
	docker-compose exec trustdomain2-server spire-server entry update \
		-entryID ${ENTRYID} \
		-parentID spiffe://trustdomain2.org/spire/agent/x509pop/f9528ed77ac34b3cfaad55513c98d53701440336 \
		-spiffeID spiffe://trustdomain2.org/echo-server \
		-selector unix:user:spiffe-envoy-agent
fi
