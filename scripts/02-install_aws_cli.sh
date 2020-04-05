#!/usr/bin/env bash

# if aws cli is not present, install it
if ! hash aws 2>/dev/null; then
    echo "Installing AWS CLI..."
    wget "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" 1>/dev/null
    unzip awscli-exe-linux-x86_64.zip 1>/dev/null
    ./aws/install 1>/dev/null
    rm -rf aws awscli-exe-linux-x86_64.zip 1>/dev/null
fi
