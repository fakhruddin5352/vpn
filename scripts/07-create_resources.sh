#!/usr/bin/env bash

if [[ -z "$AMI" ]]; then
    AMI=$(aws ec2 describe-images \
        --region $AWS_DEFAULT_REGION \
        --owners 099720109477 \
        --filters "Name=name,Values=$OS_IMAGE" \
        'Name=state,Values=available' \
        'Name=architecture,Values=x86_64' \
        --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text)
    echo
    echo
    echo "Using machine image $OS_IMAGE ( $AMI ) ..."
    echo
    echo
fi


##Create an s3 bucket
TEMPLATE_URL="${TEMPLATE_URL:-file://$(realpath ./templates/vpn.json)}"


mkdir -p .parameters
PARAMETER_PATH=".parameters/$STACK_NAME.json"
cp ./templates/parameters.json $PARAMETER_PATH
eval "cat <<EOF
$(<$PARAMETER_PATH)
EOF
" 1> $PARAMETER_PATH
PARAMETER_URL="file://$(realpath $PARAMETER_PATH)"

describe_output=$(aws cloudformation describe-stacks --region $AWS_DEFAULT_REGION --stack-name $STACK_NAME 2>&1)
status=$?


if [ $status -ne 0 ] ; then
  echo  "Stack $STACK_NAME does not exist, creating ..."
  aws cloudformation create-stack \
    --region $AWS_DEFAULT_REGION \
    --stack-name $STACK_NAME \
    --template-body $TEMPLATE_URL \
    --parameters $PARAMETER_URL 1> /dev/null

  echo "Waiting for stack to be created ..."
  if ! aws cloudformation wait stack-create-complete \
    --region $AWS_DEFAULT_REGION \
    --stack-name $STACK_NAME  1> /dev/null; then
        echo "Unable to create resources ..."
        exit 1;
  fi

else

  echo  "Stack $STACK_NAME exists, attempting update ..."

  update_output=$( aws cloudformation update-stack \
    --region $AWS_DEFAULT_REGION \
    --stack-name $STACK_NAME \
    --template-body $TEMPLATE_URL \
    --parameters $PARAMETER_URL   2>&1)
  status=$?


  if [ $status -ne 0 ] ; then

    # Don't fail for no-op update
    if [[ $update_output == *"No updates are to be performed"*  ]] ; then
      echo  "No updates are to be performed ...";
    elif [[ $update_output == *"ValidationError"* ]]; then
      echo "$update_output"
      exit 1
    fi
  else
    echo "Waiting for stack update to complete ..."
    if ! aws cloudformation wait stack-update-complete \
        --region $AWS_DEFAULT_REGION \
        --stack-name $STACK_NAME 1> /dev/null; then
        echo "Unable to create resources ..."
        exit 1;
    fi
  fi
fi

echo "Finished create/update successfully ..."

stackInfo
