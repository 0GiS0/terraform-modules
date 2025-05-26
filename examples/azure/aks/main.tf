provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

# Basic AKS cluster
module "aks_basic" {
  source = "../../../modules/azure/aks"

  name                = "aks-basic"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

# AKS cluster with autoscaling
module "aks_autoscaling" {
  source = "../../../modules/azure/aks"

  name                = "aks-autoscaling"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  default_node_pool = {
    name                = "default"
    vm_size             = "Standard_D2_v2"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
  }

  tags = {
    environment = "dev"
    managed_by  = "terraform"
    feature     = "autoscaling"
  }
}

# AKS cluster with custom network profile
module "aks_network_profile" {
  source = "../../../modules/azure/aks"

  name                = "aks-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  
  network_profile = {
    network_plugin = "kubenet"
    network_policy = "calico"
  }

  tags = {
    environment = "dev"
    managed_by  = "terraform"
    feature     = "custom-network"
  }
}