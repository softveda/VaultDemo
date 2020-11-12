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
