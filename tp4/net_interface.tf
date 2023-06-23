resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip"
  location            = var.region
  resource_group_name = var.azure_resource_group
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "terraform_network_interface" {
  name                = "terraform_network_int"
  location            = var.region
  resource_group_name = var.azure_resource_group
  

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet_tf.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm_public_ip.id
  }
}