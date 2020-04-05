#!/usr/bin/env bash


if [[ ! -z "$AWS_ACCESS_KEY_ID" ]] && [[ ! -z "$AWS_SECRET_ACCESS_KEY" ]] && [[ ! -z "$AWS_DEFAULT_REGION" ]]; then
    SKIP_CONFIGURE_AWS_CLI=1
fi

if [[ ! "$SKIP_CONFIGURE_AWS_CLI" -eq "1" ]]; then
    echo "Configuring AWS CLI"
    aws configure
    AWS_DEFAULT_REGION=$(aws configure get region );
    SKIP_CONFIGURE_AWS_CLI=1
fi

echo
echo
echo "Region $AWS_DEFAULT_REGION ...";

zone_info=$(aws ec2 describe-availability-zones \
    | jq -r '.AvailabilityZones | map(select(.State == "available" and .OptInStatus == "opt-in-not-required"))')

if [[ "$PRIMARY_AVAILABILITY_ZONE" != "$AWS_DEFAULT_REGION"* ]]; then
    zone1="$(echo "$zone_info" | jq -r '.[0].ZoneName')"
    read -p "Availability Zone 1 (empty for $zone1) : "  PRIMARY_AVAILABILITY_ZONE
    if [[ "$PRIMARY_AVAILABILITY_ZONE" != "$AWS_DEFAULT_REGION"* ]]; then
        PRIMARY_AVAILABILITY_ZONE=$zone1
        echo "Primary availability zone $PRIMARY_AVAILABILITY_ZONE ...";
    fi
fi

