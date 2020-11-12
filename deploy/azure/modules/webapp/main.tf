resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "${var.prefix}-${terraform.workspace}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }

  tags = var.tags
}

resource "azurerm_app_service" "webapp" {
  name                = "${var.prefix}-${terraform.workspace}"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  
  site_config {
     linux_fx_version = "DOTNETCORE|3.1"
     use_32_bit_worker_process = true
  }

}
