### INTRODUCTION

Create a stack file <filename> with these below variables set
```
export AWS_ACCESS_KEY_ID="<access_key>"
export AWS_SECRET_ACCESS_KEY="<secret_key>"
export STACK_NAME=my-vpn
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-west-2}"
export PRIMARY_AVAILABILITY_ZONE='us-west-2a'

```

Run

```
sudo ./game.sh <filepath>
```
