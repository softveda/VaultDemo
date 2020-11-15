kubectl apply -f todoapp-rbac.yaml
kubectl apply -f todoapp-vault-deployment.yaml
# kubectl apply -f todoapp-svc.yaml

# kubectl patch deployment todoapp --patch "$(cat todoapp-vault-agent-patch.yml)"

# journalctl -b --no-pager -f -u vault

kubectl get pods --selector=app=todoapp

kubectl exec $(k get pods --selector=app=todoapp -o jsonpath='{.items[*].metadata.name}') -c todoapp -- ls /vault/secrets
kubectl exec $(k get pods --selector=app=todoapp -o jsonpath='{.items[*].metadata.name}') -c todoapp -- sh -c 'chmod +x /vault/secrets/todoapp.config && . /vault/secrets/todoapp.config && printenv'
kubectl logs $(k get pods --selector=app=todoapp -o jsonpath='{.items[*].metadata.name}') -c vault-agent-init
kubectl exec $(k get pods --selector=app=todoapp -o jsonpath='{.items[*].metadata.name}') -c todoapp -- cat /vault/secrets/todoapp.config
