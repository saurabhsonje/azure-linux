provider "azurerm" {
	version = "=2.0.0"
	features {}
}

variable "prefixjen" {
  default = "Jenkins"
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
resource "azurerm_linux_virtual_machine" "JenkinsVm" {
    name                  = "${var.prefixjen}-vm"
    location              = data.terraform_remote_state.remote.outputs.rglocation
    resource_group_name   = data.terraform_remote_state.remote.outputs.rgname
    size                  = "Standard_DS1_v2"
    admin_username      = "adminuser"
    network_interface_ids = [azurerm_network_interface.nic.id]
   
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
output "JenkinsIp"{

	value = data.azurerm_public_ip.JenkinsIp.ip_address
}

/*resource "azurerm_network_interface" "nic" {
  name                = "azurerm-nic"
  location            = data.terraform_remote_state.remote.outputs.rglocation
  resource_group_name = data.terraform_remote_state.remote.outputs.rgname

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.terraform_remote_state.remote.outputs.subnetId
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = azurerm_public_ip.publicip1.id

  }
}

resource "azurerm_public_ip" "publicip1" {
    name                         = "myPublicIP1"
    location                     = data.terraform_remote_state.remote.outputs.rglocation
    resource_group_name          = data.terraform_remote_state.remote.outputs.rgname
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

data "azurerm_public_ip" "JenkinsIp" {
  name                = azurerm_public_ip.publicip1.name
  resource_group_name = azurerm_linux_virtual_machine.JenkinsVm.resource_group_name
}*/


