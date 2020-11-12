output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.storage_account.primary_blob_endpoint
}

output "storage_account_primary_access_key" {
  value = azurerm_storage_account.storage_account.primary_access_key
}

output "storage_account_primary_connection_string" {
  value = azurerm_storage_account.storage_account.primary_connection_string
}