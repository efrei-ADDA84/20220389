resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "devops-20220389"
  location              = var.region
  resource_group_name   = var.azure_resource_group
  network_interface_ids = [azurerm_network_interface.terraform_network_interface.id]
  size                  = var.vm_size
  
  os_disk {
    name                 = "20220389_OS"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = var.user_admin
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.user_admin
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  custom_data = filebase64("cloud-init.yml")


}