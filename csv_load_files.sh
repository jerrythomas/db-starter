#!/usr/bin/env bash

ROOT=data/$ENV/import

if [ -f "$ROOT/tables.txt" ]; then
    while read TABLE_NAME
    do
        FILE_NAME=`echo $TABLE_NAME | tr "." "/"`
        echo "\\copy ${TABLE_NAME} from '${ROOT}/${FILE_NAME}.csv' with delimiter ',' csv header;" | psql $DATABASE_URL
    done < "$ROOT/tables.txt"
fi
