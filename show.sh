#!/usr/bin/env bash

source env.sh
source scripts/00-common.sh
runAsRoot

source scripts/01-install_packages.sh
source scripts/02-install_aws_cli.sh
stackInfo

source scripts/03-configure_aws_cli.sh



echo "Primary instance id is $PRIMARY_INSTANCE_ID"

PRIMARY_INSTANCE_DNS_NAME="$(aws ec2 describe-instances --instance-ids $PRIMARY_INSTANCE_ID \
    --query "Reservations[*].Instances[0].PublicDnsName" \
    --output text 2>/dev/null)"

echo
echo
echo "You can ssh your primary instance at ubuntu@$PRIMARY_INSTANCE_DNS_NAME ..."
echo "Your ssh key is at $KEY_PATH."
echo "sudo ssh -i $KEYPATH ubuntu@$PRIMARY_INSTANCE_DNS_NAME"
echo "Thank you"