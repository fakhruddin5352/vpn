#!/usr/bin/env bash

source env.sh
source scripts/00-common.sh
runAsRoot

stackInfo

CLIENT_NAME=$1
install_dir=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)

for i in `ls make_client/*.sh | sort -V`; do
    echo "#!/usr/bin/env bash

CLIENT_NAME=$CLIENT_NAME
VOLUME_NAME=$VOLUME_NAME
DOMAIN=$PRIMARY_INSTANCE_DNS_NAME


$(cat $i)
" | ssh -i $KEY_PATH -o BatchMode=yes -o StrictHostKeyChecking=no \
     -o ServerAliveInterval=3 ubuntu@$PRIMARY_INSTANCE_DNS_NAME  \
    "mkdir -p $install_dir/make_client && cat > $install_dir/$i && sudo chown root:root $install_dir/$i && sudo chmod 700 $install_dir/$i"

    if [[ $? -ne 0 ]]; then
        echo -e "\e[1;31m Script $i failed \e[0m"
        exit $?;
    fi
    echo -e "\e[1;34m Executing script $install_dir/$i on $PRIMARY_INSTANCE_DNS_NAME \e[0m"

    ssh -t -t -o BatchMode=yes -o StrictHostKeyChecking=no \
     -o ServerAliveInterval=3 \
     -i $KEY_PATH ubuntu@$PRIMARY_INSTANCE_DNS_NAME "sudo /home/ubuntu/$install_dir/$i && exit"

    if [[ $? -ne 0 ]]; then
        echo -e "\e[1;31m Script $i failed \e[0m"
        exit $?;
   fi
done

mkdir -p /.clients
rsync -av -e "ssh -o StrictHostKeyChecking=no -i $KEY_PATH" ubuntu@$PRIMARY_INSTANCE_DNS_NAME:/home/ubuntu/$CLIENT_NAME.ovpn /.clients
echo "Client conrig written to /.clients/$CLIENT_NAME.ovpn"
