#!/bin/bash

# Get app from blob
export blob_url=<blob_url>
export sas=<sas>
azcopy copy "$blob_url/todoexporterv1/$sas" "." --recursive=true

read aws_access_key aws_secret_key < <(echo $(vault read aws/creds/exporter-s3-role -format=json | jq -r '.data.access_key .data.secret_key'))
echo ${aws_access_key} ${aws_secret_key}
db_server=$(vault kv get -field=DB_SERVER secret/exporter/config)
read db_user db_password < <(echo $(vault read azuresql/creds/exporter-role -format=json | jq -r '.data.username .data.password'))
echo ${db_server} ${db_user} ${db_password}

# Allow IAM policies to propagate
sleep 20s

dotnet todoexporterv1/app/TodoExporter.dll \
        --DB:server=${db_server} \
        --DB:user=${db_user} \
        --DB:password=${db_password} \
        --AWS:access_key=${aws_access_key} \
        --AWS:secret_key=${aws_secret_key}