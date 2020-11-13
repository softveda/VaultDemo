variable "tag_app" {
  default = "HashicorpDemo"
}

variable "prefix" {
  description = "The beginning part of resource names"
}

variable "location" {
  description = "The location of resources"
  default     = "westus"
}

# SQL Database
variable "db_user" {
  description = "The SQL Server Admin username"
}

variable "db_password" {
  description = "The SQL Server Admin password"
}

variable "db_sku" {
  description = "The SQL DB SKU"
  default     = "basic"
}

variable "db_name" {
  description = "The SQL DB name"
}

variable "isp_client_ip" {
  description = "IP address of your ISP"
}