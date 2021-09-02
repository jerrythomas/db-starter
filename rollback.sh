#!/usr/bin/env bash
ENV=${ENV:-development}

if [ -z "${DATABASE_URL+x}" ]; then
    echo "DATABASE_URL is not defined." && exit 1
fi

echo "Rolling back incremental changes in [$ENV]."

# reverse data changes before reversing structural changes
if [ $ENV != "production" ]
then
   echo "Rolling back $ENV data."
   . data/$ENV/rollback.sh
fi
psql $DATABASE_URL < rollback/data.sql

# Rollback structural changes
psql $DATABASE_URL < rollback/drop.ddl
psql $DATABASE_URL < rollback/alter.ddl
psql $DATABASE_URL < rollback/views.ddl
