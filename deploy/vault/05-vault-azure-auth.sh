export VAULT_ADDR=<VAULT_ADDR>

vault kv put secret/exporter/config DB_SERVER=<SERVER>

vault policy write exporter-policy - <<EOF
path "/secret/data/exporter/*" {
capabilities = ["read", "list"]
}
EOF

vault write auth/azure/config \
    tenant_id=<TENANT> \
    resource=https://management.azure.com/

vault write auth/azure/role/exporter-role \
    policies="exporter-policy" \
    bound_subscription_ids=<SUBSCRIPTION> \
    bound_resource_groups=hashidemo-dev-rg \
    max_ttl=24h

# vault lease revoke -prefix azuresql/creds/exporter-role