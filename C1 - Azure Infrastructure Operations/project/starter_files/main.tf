provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    "project": var.project_tag
  }	

}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    "project": var.project_tag
  }	

}

resource "azurerm_network_security_rule" "subnet_only" {
  name                        = "subnet-only-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name

}

resource "azurerm_network_security_rule" "deny_all" {
  name                        = "deny-all-rule"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name

}


resource "azurerm_subnet" "main" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "main" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    "project": var.project_tag
  }	
}

resource "azurerm_lb" "main" {
  name                = "${var.prefix}LoadBalancer"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
  }
  tags = {
    "project": var.project_tag
  }	
}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id     = azurerm_lb.main.id
  name                = "BackEndAddressPool"

 
}

resource "azurerm_network_interface" "main" {

  count = var.vm_count

  name                = "${var.prefix}-nic-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    
  }

  tags = {
    "project": var.project_tag
  }	
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {

    count = var.vm_count

    network_interface_id    = azurerm_network_interface.main[count.index].id
    ip_configuration_name   = "internal"
    backend_address_pool_id =azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-aset"
  location            = var.location
  resource_group_name = var.resource_group_name
  platform_fault_domain_count = var.fault_domain_count

  tags = {
    "project": var.project_tag
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  
  count = var.vm_count

  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = var.resource_group_name
  availability_set_id             = azurerm_availability_set.main.id
  location                        = var.location
  size                            = "Standard_D2s_V3"
  
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main[count.index].id
  ]
  source_image_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/images/${var.image_name}"

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    "project": var.project_tag
  }	
}