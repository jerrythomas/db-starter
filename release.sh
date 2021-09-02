#!/usr/bin/env bash
ENV=${ENV:-development}
BASE_PATH=`pwd`

if [ -z "${DATABASE_URL+x}" ]; then
    echo "DATABASE_URL is not defined." && exit 1
fi

echo -e "\nRunning in [$ENV].\n"

psql $DATABASE_URL < setup/extensions.ddl
psql $DATABASE_URL < setup/schemas.ddl
psql $DATABASE_URL < setup/tables.ddl
psql $DATABASE_URL < setup/functions.ddl

# Staging tables, views and functions
psql $DATABASE_URL < setup/staging/tables.ddl
psql $DATABASE_URL < setup/staging/views.ddl
psql $DATABASE_URL < setup/staging/functions.ddl

psql $DATABASE_URL < setup/alter.ddl
psql $DATABASE_URL < setup/views.ddl

./csv_load_files.sh "$BASE_PATH/setup/metadata"
psql -v base_path="$BASE_PATH/setup" $DATABASE_URL < setup/metadata/incremental.sql

./staging.sh

# Run additional scripts specific to the environment
if [ $ENV != "production" ]
then
  echo -e "Running import scripts for $ENV\n"

  ./data/$ENV/release.sh
fi
