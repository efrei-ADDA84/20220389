data "azurerm_virtual_network" "network_tf" {
  name                = var.network
  resource_group_name = var.azure_resource_group
}

data "azurerm_subnet" "subnet_tf" {
  name                 = var.subnet
  virtual_network_name = var.network
  resource_group_name  = var.azure_resource_group
}

