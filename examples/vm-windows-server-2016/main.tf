resource "azurerm_resource_group" "example" {
  name     = "rg-sre-team"
  location = "southeastasia"
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-sre"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  tags = {
    Env = "Demo"
    DR  = "NONE"
  }
}

module "virtual_machine" {
  source              = "../../"
  name                = "tricentis"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  fqdn                = "tricentis"
  subnet_id           = element(azurerm_virtual_network.example.subnet.*.id, 0)
  admin_username      = "sre123"
  admin_password      = "adMin%6541"
  image               =  {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  tags = {
    Env = "Demo"
    DR  = "NONE"
  }
}
