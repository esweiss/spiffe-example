#/bin/bash

set -e

bb=$(tput bold)
nn=$(tput sgr0)

ENTRYID=$(docker-compose exec -T trustdomain2-server spire-server entry show | grep -m1 "Entry ID" | awk '{print $3}')
if [[ ! -z ${ENTRYID} ]]; then
	echo ${bb}Deleting entry ${ENTRYID}${nn}...
	docker-compose exec -T trustdomain2-server spire-server entry delete -entryID ${ENTRYID} > /dev/null
fi

ENTRYID=$(docker-compose exec -T trustdomain1-server spire-server entry show | grep -m1 "Entry ID" | awk '{print $3}')
if [[ ! -z ${ENTRYID} ]]; then
	echo ${bb}Deleting entry ${ENTRYID}${nn}...
	docker-compose exec -T trustdomain1-server spire-server entry delete -entryID ${ENTRYID} > /dev/null
fi
