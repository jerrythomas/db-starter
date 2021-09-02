#!/usr/bin/env bash
MODE=${1:-incremental}
ENV=${ENV:-production}
BASE_PATH=`pwd`

if [ -z "${DATABASE_URL+x}" ]; then
    echo "DATABASE_URL is not defined." && exit 1
fi

echo -e "\nRunning in [$ENV] \n"
psql $DATABASE_URL < setup/staging/cleanup.sql
./csv_load_files.sh "data/$ENV/import"
psql $DATABASE_URL < setup/staging/upload.sql
