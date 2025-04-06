#!/bin/bash
set -eo pipefail

host="$(hostname -i || echo '127.0.0.1')"
user="${POSTGRES_USER:-postgres}"
db="${POSTGRES_DB:-$POSTGRES_USER}"
export PGPASSWORD="${POSTGRES_PASSWORD:-}"

args=(
	# force postgres to not use the local unix socket (test "external" connectibility)
	--host "$host"
	--username "$user"
	--dbname "$db"
	--quiet --no-align --tuples-only
)

for i in {1..5}; do
	if select="$(echo 'SELECT 1' | psql "${args[@]}")" && [ "$select" = '1' ]; then
		exit 0
	fi
	echo "Attempt  $i/5 failed. Retrying in 2 seconds..."
	sleep 2
	
done

exit 1
