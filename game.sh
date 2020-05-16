#!/usr/bin/env bash

STACK_NAME=aws.2.stack
./auto_install.sh ./stacks/$STACK_NAME
./auto_client.sh ./stacks/$STACK_NAME jooan
./auto_client.sh ./stacks/$STACK_NAME farrukh
./auto_client.sh ./stacks/$STACK_NAME kashif
./auto_client.sh ./stacks/$STACK_NAME daniyal
./auto_client.sh ./stacks/$STACK_NAME khurram
./auto_client.sh ./stacks/$STACK_NAME fakhrus
./auto_client.sh ./stacks/$STACK_NAME extra1
./auto_client.sh ./stacks/$STACK_NAME extra2



