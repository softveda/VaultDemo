output "web_app_name" {
  value = azurerm_app_service.webapp.name
}

output "web_app_fqdn" {
  value = azurerm_app_service.webapp.default_site_hostname
}