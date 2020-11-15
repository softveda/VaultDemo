az aks get-credentials -g hashidemo-platform-rg -n hashidemo-aks
kubectl config get-contexts

export VAULT_ADDR=<VAULT_ADDR>
helm repo add hashicorp https://helm.releases.hashicorp.com
helm search repo hashicorp/vault
helm install vault hashicorp/vault --set injector.externalVaultAddr=$VAULT_ADDR
helm status vault
helm get manifest vault

kubectl create serviceaccount simpleapp-auth
kubectl apply -f todoapp-rbac.yml