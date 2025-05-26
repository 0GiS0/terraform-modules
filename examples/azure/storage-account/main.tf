provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

# Basic storage account
module "storage_account_basic" {
  source = "../../../modules/azure/storage-account"

  name                = "basicstorageaccount"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  
  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

# Storage account with network rules
module "storage_account_network_rules" {
  source = "../../../modules/azure/storage-account"

  name                = "networkrulessa"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  
  network_rules = {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = ["203.0.113.0/24"]
    virtual_network_subnet_ids = []
  }
}

# Storage account with containers
module "storage_account_containers" {
  source = "../../../modules/azure/storage-account"

  name                = "containerssa"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  
  containers = {
    "documents" = {
      access_type = "private"
    }
    "images" = {
      access_type = "blob"
    }
    "public-data" = {
      access_type = "container"
    }
  }
}

# Storage account with blob properties
module "storage_account_blob_properties" {
  source = "../../../modules/azure/storage-account"

  name                = "blobpropertiesstg"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  
  account_kind = "StorageV2"
  access_tier  = "Hot"
  
  blob_properties = {
    versioning_enabled       = true
    change_feed_enabled      = true
    last_access_time_enabled = true
    delete_retention_policy = {
      days = 7
    }
    container_delete_retention_policy = {
      days = 7
    }
  }
}