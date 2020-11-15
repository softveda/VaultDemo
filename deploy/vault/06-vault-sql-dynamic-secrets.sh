export VAULT_ADDR=<VAULT_ADDR>

vault secrets enable -path=azuresql database

vault write azuresql/config/todo-mssql-database \
    plugin_name=mssql-database-plugin \
    connection_url='server=<SERVER>;port=1433;user id=<USER>;password=<PASSWORD>;database=TodoDB;app name=vault;' \
    allowed_roles="exporter-role"

vault write azuresql/roles/exporter-role \
    db_name=todo-mssql-database \
    creation_statements="CREATE USER [{{name}}] WITH PASSWORD = '{{password}}'; GRANT SELECT ON SCHEMA::dbo TO [{{name}}];" \
    revocation_statements="DROP USER IF EXISTS [{{name}}]" \
    default_ttl="1h" \
    max_ttl="24h"

vault policy write exporter-policy - <<EOF
path "/secret/data/exporter/*" {
capabilities = ["read", "list"]
}
# Get credentials from the azure sql db secrets engine
path "azuresql/creds/exporter-role" {
  capabilities = [ "read" ]
}
EOF

# dynamic secret
vault read azuresql/creds/exporter-role

# vault lease revoke -prefix azuresql/roles/exporter-role