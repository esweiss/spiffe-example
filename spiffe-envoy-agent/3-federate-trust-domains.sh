#!/bin/bash

set -e

bb=$(tput bold)
nn=$(tput sgr0)

# Cross federate each trust domain by dumping the bundle in one and setting it
# in the other and vice versa.
echo "${bb}Federating trustdomain1.org and trustdomain2.org...${nn}"
docker-compose exec -T trustdomain1-server spire-server experimental bundle show | \
	docker-compose exec -T trustdomain2-server spire-server experimental bundle set > /dev/null
docker-compose exec -T trustdomain2-server spire-server experimental bundle show | \
	docker-compose exec -T trustdomain1-server spire-server experimental bundle set > /dev/null
