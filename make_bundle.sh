#!/usr/bin/env bash
rm -r -f bundle
mkdir -p bundle
cp -R scripts bundle/
cp -R install bundle/
cp -R templates bundle/
cp -R make_client bundle/
cp auto_install.sh bundle/
cp auto_cleanup.sh bundle/
cp auto_client.sh bundle/
cp install.sh bundle/
cp make_client.sh bundle/
cp show.sh bundle/
cp env.sh bundle/
cp cleanup.sh bundle/


