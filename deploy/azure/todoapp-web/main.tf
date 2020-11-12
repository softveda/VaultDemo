terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.35.0"
    }
  }

  backend "azurerm" {
    features {}
  }
}

provider "azurerm" {
  features {}
}

locals {
  tags = {
    app         = var.tag_app
    environment = terraform.workspace
  }
}

# Resource Group
module "resource_group" {
  source = "../modules/resourcegroup"

  resource_group_name = "${var.prefix}-${terraform.workspace}"
  location            = var.location

  tags = local.tags
}


# Storage Account
module "storage_account" {
  source = "../modules/storageaccount"

  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  prefix              = "hashidemo"

  tags = local.tags

}

module "sqldatabase" {
  source = "../modules/sqldatabase"

  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  prefix              = "hashidemo"

  db_user     = var.db_user
  db_password = var.db_password
  db_sku      = var.db_sku
  db_name     = var.db_name

  isp_client_ip = var.isp_client_ip

  tags = local.tags
}

# App Service Web App
module "webapp" {
  source = "../modules/webapp"

  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  prefix              = "todoapp-hashidemo"

  tags = local.tags
}
