#!/bin/bash

# Run in workload VM

export VAULT_ADDR=<VAULT_ADDR>

export VAULT_TOKEN=$(vault write auth/azure/login \
     role="exporter-role" \
     jwt="$(curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F' -H Metadata:true | jq -r '.access_token')" \
     subscription_id=$(curl -s -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | jq -r '.compute | .subscriptionId')  \
     resource_group_name=$(curl -s -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | jq -r '.compute | .resourceGroupName') \
     vm_name=$(curl -s -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | jq -r '.compute | .name') \
     -format=json | jq -r '.auth.client_token')

vault login $VAULT_TOKEN
