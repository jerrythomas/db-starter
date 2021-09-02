#!/usr/bin/env bash
ENV=${ENV:-development}
BASE_PATH=`pwd`
ROOT="$BASE_PATH/data/$ENV/export"

if [ -z "${DATABASE_URL+x}" ]; then
    echo "DATABASE_URL is not defined." && exit 1
fi

if [ ! -f "$ROOT/tables.txt" ]; then
    echo "No such file [$ROOT/tables.txt]" && exit 1
fi

while read TABLE_NAME
do
    SCHEMA_NAME=`echo $TABLE_NAME | cut -d '.' -f1`
    FILE_NAME=`echo $TABLE_NAME | cut -d '.' -f2`
    mkdir -p ${ROOT}/${SCHEMA_NAME}
    echo "\\copy (select * from ${TABLE_NAME}) to '${ROOT}/${SCHEMA_NAME}/${FILE_NAME}.csv' with delimiter ',' csv header;" | psql $DATABASE_URL
done < "$ROOT/tables.txt"
