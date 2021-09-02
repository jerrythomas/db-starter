#!/usr/bin/env bash
SCRIPT=$1
ENV=${ENV:-development}
BASE_PATH=`pwd`

if [ -z "${DATABASE_URL+x}" ]; then
    echo "DATABASE_URL is not defined." && exit 1
fi

if [ $ENV != "production" ]
then
    if [ ! -f "data/$ENV/$SCRIPT" ]; then
        echo "No such file [data/$ENV/$SCRIPT]"
    else
        mkdir -p data/$ENV/export
        echo "Running $ENV script $SCRIPT"
        psql -v base_path="$BASE_PATH/data/$ENV" $DATABASE_URL < data/$ENV/$SCRIPT
    fi
fi