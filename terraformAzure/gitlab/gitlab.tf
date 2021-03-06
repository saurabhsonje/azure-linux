provider "azurerm" {
	version = "=2.0.0"
	features {}
}

variable "prefixjen" {
  default = "Gitlab"
}

data "terraform_remote_state" "remote" {
  backend = "azurerm"
  config = {
    resource_group_name  = "DAL"
    storage_account_name = "azurermstorage"
    container_name       = "azurermcontainer"
    key                  = "terraform.tfstate"
  }

}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "GitlabVm" {
    name                  = "${var.prefixjen}-vm"
    location              = data.terraform_remote_state.remote.outputs.rglocation
    resource_group_name   = data.terraform_remote_state.remote.outputs.rgname
    size                  = "Standard_DS1_v2"
   
    network_interface_ids = [azurerm_network_interface.nic3.id]
    os_disk {
       name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    computer_name  = "myvm"
    admin_username = "azureuser"
    admin_password = "test@1234"

    tags = {
        environment = "Terraform Demo"
    }
 
}

resource "azurerm_network_interface" "nic3" {
  name                = "azurerm-nic"
  location            = data.terraform_remote_state.remote.outputs.rglocation
  resource_group_name = data.terraform_remote_state.remote.outputs.rgname

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.terraform_remote_state.remote.outputs.subnetId
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = azurerm_public_ip.publicip3.id

  }
}

resource "azurerm_public_ip" "publicip3" {
    name                         = "myPublicIP3"
    location                     = data.terraform_remote_state.remote.outputs.rglocation
    resource_group_name          = data.terraform_remote_state.remote.outputs.rgname
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

data "azurerm_public_ip" "GitlabIp" {
  name                = azurerm_public_ip.publicip3.name
  resource_group_name = azurerm_linux_virtual_machine.GitlabVm.resource_group_name
}

output "GitlabIp"{

	value = data.azurerm_public_ip.GitlabIp.ip_address
}
