#!/usr/bin/env bash

source env.sh
source scripts/00-common.sh
runAsRoot

for i in `ls scripts/*.sh | sort -V`; do
    if [[ $i != "scripts/00-common.js" ]]; then
        source $i
    fi
done;
