#!/usr/bin/env bash

source env.sh
source scripts/00-common.sh
runAsRoot

STACK_ID="$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query "Stacks[0].StackId" \
    --output text 2>/dev/null)"

if [[ -z "$STACK_ID" ]]; then
    echo "Stack $STACK_NAME does not exist ...";
    exit 1;
fi

echo "Removing images and snapshots ...";
removeImage $IMAGE_NAME

echo "Deleting stack $STACK_NAME ...";
aws cloudformation delete-stack --stack-name $STACK_NAME;

if ! aws cloudformation wait stack-delete-complete \
--stack-name $STACK_NAME  1> /dev/null; then
    echo "Unable to delete stack ..."
    exit 1;
fi

echo "Deleted $STACK_NAME successfully ..."
echo
echo


