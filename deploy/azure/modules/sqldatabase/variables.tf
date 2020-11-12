variable "tags" {
  description = "Tags to set on the resource."
  type = map(string)
  default = {}
}

variable "resource_group_name" {
  description = "The name of the resource group"
}

variable "location" {
  description = "The location of resource group"
}

variable "prefix" {
  description = "The beginning part of resource names"
}

variable "db_user" {
  description = "The SQL Server Admin username"
}

variable "db_password" {
  description = "The SQL Server Admin password"
}

variable "db_name" {
  description = "The SQL DB name"
}