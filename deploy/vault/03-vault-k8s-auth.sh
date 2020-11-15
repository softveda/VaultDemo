export VAULT_ADDR=<VAULT_ADDR>
vault login <TOKEN>

export SA_NAME=$(kubectl get sa todoapp-auth -o jsonpath="{.secrets[*]['name']}")
echo $SA_NAME

export SA_JWT=$(kubectl get secret $SA_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
echo $SA_JWT

kubectl get secret $SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode | tee ca_cert.pem
openssl x509 -in ca_cert.pem -text -noout

export K8S_API_SVR=$(kubectl config view -o jsonpath="{.clusters[1].cluster.server}")
echo $K8S_API_SVR

vault auth enable kubernetes
vault write auth/kubernetes/config \
  token_reviewer_jwt=$SA_JWT \
  kubernetes_host=$K8S_API_SVR \
  kubernetes_ca_cert=@ca_cert.pem \
  disable_iss_validation=true \
  disable_local_ca_jwt=true

vault read auth/kubernetes/config

vault kv put secret/todoapp/config GREETING="HelloFromVault" DB_USER=SqlUser DB_PASSWORD=Pa55w.rd1234
vault kv get secret/todoapp/config

vault policy write todoapp-policy - <<EOF
path "/secret/data/todoapp/*" {
  capabilities = ["read", "list"]
}
EOF

vault write auth/kubernetes/role/todoapp-role \
  policies="todoapp-policy" \
  bound_service_account_names=todoapp-auth \
  bound_service_account_namespaces=default \
  ttl=24h

# curl -s -k --request POST --data '{"jwt": "'"$SA_JWT"'", "role": "todoapp-role"}' $VAULT_ADDR/v1/auth/kubernetes/login | jq