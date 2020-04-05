#!/usr/bin/env bash

mkdir -p $KEY_FOLDER
if [[ ! "$SKIP_CREATE_KEYS" -eq "1" ]]; then
    echo "Checking if AWS Key pair $KEYPAIR_NAME exists..."
    KEY_PAIR_ID=$(aws ec2  describe-key-pairs \
        --key-names ${KEYPAIR_NAME} \
        --output text --query 'KeyPairId' 2>/dev/null)
    if [[ -z "$KEY_PAIR_ID" ]]; then
        echo "Key pair does not exist. Create a new pair..."
        aws ec2 create-key-pair --key-name ${KEYPAIR_NAME} --output text --query 'KeyMaterial' 1> $KEY_PATH
        echo "Key saved to $KEY_PATH. Save this to access the newly created host"
    else
        echo "Using the keypair ${KEYPAIR_NAME} at ${KEY_PATH}"
    fi
    SKIP_CREATE_KEYS=1
fi

chmod 400 $KEY_PATH