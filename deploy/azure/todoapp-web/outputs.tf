output "resource_group_name" {
  value       = module.resource_group.resource_group_name
  description = "Resource Group Name"
}

output "storage_account_name" {
  value = module.storage_account.storage_account_name
}

output "storage_account_primary_blob_endpoint" {
  value = module.storage_account.storage_account_primary_blob_endpoint
}

output "storage_account_primary_access_key" {
  value = module.storage_account.storage_account_primary_access_key
}

output "storage_account_primary_connection_string" {
  value = module.storage_account.storage_account_primary_connection_string
}

output "sql_server_fqdn" {
  value = module.sqldatabase.sql_server_fqdn
}

output "sql_database_name" {
  value = module.sqldatabase.sql_database_name
}

output "web_app_name" {
  value = module.webapp.web_app_name
}

output "web_app_fqdn" {
  value = module.webapp.web_app_fqdn
}