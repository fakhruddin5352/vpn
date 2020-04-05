#!/usr/bin/env bash

source scripts/00-common.sh


STACK_NAME="${STACK_NAME:-fsvpn)}"
DOMAIN="${DOMAIN:-fakhruddinsaleem.xyz}"
VOLUME_NAME="${VOLUME_NAME:-$STACK_NAME}"

KEY_FOLDER="${KEY_FOLDER:-$(realpath /.keys)}"
KEYPAIR_NAME="${KEYPAIR_NAME:-$STACK_NAME}"
KEY_PATH="$KEY_FOLDER/${KEYPAIR_NAME}.pem"


AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-west-2}"


##Set this to isntall a particular image, alternatively set
##the OS_IMAGE variable and it will search for latest AMI for os
AMI=''
OS_IMAGE="${OS_IMAGE:-ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-????????}"

INSTANCE_TYPE="${INSTANCE_TYPE:-t2.micro}"
CIDR_VPC_IP="${CIDR_VPC_IP:-10.0.0.0}"
CIDR_VPC=$CIDR_VPC_IP/16
CIDR_EVERYONE=0.0.0.0/0

PRIMARY_AVAILABILITY_ZONE="${PRIMARY_AVAILABILITY_ZONE:-}"
PRIMARY_CIDR_BLOCK="${PRIMARY_CIDR_BLOCK:-10.0.1.0/24}"
