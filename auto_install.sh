#!/usr/bin/env bash

export AWS_DEFAULT_OUTPUT="${AWS_DEFAULT_OUTPUT:-json}"

source $1
./cleanup.sh
./install.sh