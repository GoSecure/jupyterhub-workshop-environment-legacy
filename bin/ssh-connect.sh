#!/bin/bash

TF_STATE_FILE=terraform.tfstate

echo Extracting SSH key from terraform state
jq -r '.resources[]|select(.module == "module.jupyter-hub-workshop" and .type == "tls_private_key")|.instances[0].attributes.private_key_pem' $TF_STATE_FILE > tmp_sshkey
chmod u=rw,go= tmp_sshkey

IP=$(jq -r '.resources[]|select(.module == "module.jupyter-hub-workshop" and .type == "digitalocean_droplet")|.instances[0]|.attributes.ipv4_address' $TF_STATE_FILE)

echo "Connecting with ssh ($IP)"
set -x
ssh -i tmp_sshkey root@$IP
