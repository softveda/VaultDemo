#!/bin/bash

export VAULT_ADDR=https://vault-1.devopscraft.tech:8200
export MDS_URL=http://169.254.169.254

export VAULT_TOKEN=$(vault write auth/azure/login \
     role="exporter-role" \
     jwt="$(curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F' -H Metadata:true | jq -r '.access_token')" \
     subscription_id=$(curl -s -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | jq -r '.compute | .subscriptionId')  \
     resource_group_name=$(curl -s -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | jq -r '.compute | .resourceGroupName') \
     vm_name=$(curl -s -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | jq -r '.compute | .name') \
     -format=json | jq -r '.auth.client_token')

vault login $VAULT_TOKEN

read aws_access_key aws_secret_key < <(echo $(vault read aws/creds/exporter-s3-role -format=json | jq -r '.data.access_key .data.secret_key'))
echo ${aws_access_key} ${aws_secret_key}
db_server=$(vault kv get -field=DB_SERVER secret/exporter/config)
read db_user db_password < <(echo $(vault read azuresql/creds/exporter-role -format=json | jq -r '.data.username .data.password'))
echo ${db_server} ${db_user} ${db_password}

# Allow IAM policies to propagate
sleep 20s

# Download app from blob
rm -rf todoexporterv1
blob_url=""
sas=""
azcopy copy "$blob_url/todoexporterv1/$sas" "." --recursive=true

dotnet todoexporterv1/app/TodoExporter.dll \
--DB:server=${db_server} \
--DB:user=${db_user} \
--DB:password=${db_password} \
--AWS:access_key=${aws_access_key} \
--AWS:secret_key=${aws_secret_key}