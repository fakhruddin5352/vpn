#!/usr/bin/env bash

yesNo() {
    while true; do
        read -p "$1? [y/n]" yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit $2;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

runAsRoot() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "Sorry, you need to run this as root"
        exit
    fi
}

prompt() {

 prompt_result=
 while true; do
    read -p "$1: " prompt_result
    if [[ -z "$prompt_result" ]]; then
        echo
    else
        break
    fi
  done
}

promptPassword() {

 prompt_result=
 while true; do
    read  -s -p "$1: " prompt_result
    echo
    if [[ -z "$prompt_result" ]]; then
        :
    else
        break
    fi
  done

}


stackInfo() {

outputs=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query "Stacks[0].Outputs" \
    --output json)
for row in $(echo "${outputs}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

    _output_eval() {
        local key=$(_jq '.OutputKey'  \
            | sed -r 's/([A-Z])/_\L\1/g' \
            | sed 's/^_//' \
            | sed 's/[a-z]/\U&/g')
        local value=$(_jq '.OutputValue')
        eval "$key=$value"
    }
    _output_eval
done
}


function removeImage() {
    local image_ids=$(aws ec2 describe-images --filters "Name=name,Values=$1" \
        --owners self --output json --query 'Images[0].[ImageId, BlockDeviceMappings[0].Ebs.SnapshotId]' 2>/dev/null)

    local image_id_length=$(echo "$image_ids" | jq '. | length');

    if [[ $image_id_length -ne 0 ]]; then
        local image_id=$(echo "$image_ids" | jq -r '.[0]')
        echo "Image $1 already exists, removing ... ";
        aws ec2 deregister-image --image-id $image_id 1>/dev/null

        local snapshot_id=$(echo "$image_ids" | jq  -r '.[1]')
        echo "Snapshot id $snapshot_id already exists, removing ...";
        aws ec2 delete-snapshot --snapshot-id $snapshot_id 1>/dev/null
    fi
}