
resource "azurerm_sql_server" "sql_server" {
  name                         = "${var.prefix}-${terraform.workspace}-sqlserver"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.db_user
  administrator_login_password = var.db_password

  tags = var.tags
}

resource "azurerm_sql_firewall_rule" "azurerule" {
  name                = "AllowAccessToAzureServices"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

variable "isp_client_ip" {
  description = "IP address of your ISP"
}

resource "azurerm_sql_firewall_rule" "isprule" {
  name                = "AllowAccessToISP"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sql_server.name
  start_ip_address    = var.isp_client_ip
  end_ip_address      = var.isp_client_ip
}

variable "db_sku" {
  description = "The SQL DB SKU"
  default     = "basic"
}

resource "azurerm_sql_database" "sql_database" {
  name                = var.db_name
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.sql_server.name
  edition             = var.db_sku

  tags = var.tags

}
