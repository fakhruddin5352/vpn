#!/usr/bin/env bash
# install certbot unzip

if [[ ! "$SKIP_INSTALL_PACKAGES" -eq "1" ]]; then
    echo "Installing required packages ..."
    apt-get update
    apt-get install  unzip jq -y
    SKIP_INSTALL_PACKAGES=1
fi