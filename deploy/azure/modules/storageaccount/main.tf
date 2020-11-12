resource "random_integer" "suffix" {
  min     = 1000
  max     = 9999
}

resource "azurerm_storage_account" "storage_account" {
  name                = "${var.prefix}${terraform.workspace}${random_integer.suffix.result}"
  resource_group_name = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}