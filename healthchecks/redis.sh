#!/bin/sh
# shellcheck disable=SC3040
set -eo pipefail

host="$(hostname -i || echo '127.0.0.1')"

for i in {1..5}; do
	if ping="$(redis-cli -h "$host" ping)" && [ "$ping" = 'PONG' ]; then
		exit 0
	fi
	echo "Attempt  $i/5 failed. Retrying in 2 seconds..."
	sleep 2
	
done

exit 1
