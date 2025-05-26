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
    private_link_access = [
      {
        endpoint_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.Sql/servers/example-sql-server"
      }
    ]
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
    cors_rule = [
      {
        allowed_headers    = ["*"]
        allowed_methods    = ["GET", "POST", "PUT"]
        allowed_origins    = ["https://example.com"]
        exposed_headers    = ["*"]
        max_age_in_seconds = 3600
      }
    ]
  }
}

# Storage account with static website
module "storage_account_static_website" {
  source = "../../../modules/azure/storage-account"

  name                = "staticwebsitestg"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  account_kind = "StorageV2"

  static_website = {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

# Storage account with queue properties
module "storage_account_queue_properties" {
  source = "../../../modules/azure/storage-account"

  name                = "queuepropertiesstg"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  queue_properties = {
    cors_rule = [
      {
        allowed_headers    = ["*"]
        allowed_methods    = ["GET", "POST"]
        allowed_origins    = ["https://example.com"]
        exposed_headers    = ["*"]
        max_age_in_seconds = 3600
      }
    ]
    logging = {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 7
    }
  }
}

# Storage account with share properties
module "storage_account_share_properties" {
  source = "../../../modules/azure/storage-account"

  name                = "sharepropertiesstg"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  account_kind = "FileStorage"
  account_tier = "Premium"

  share_properties = {
    retention_policy = {
      days = 7
    }
    smb = {
      versions                        = ["SMB3.0", "SMB3.1.1"]
      authentication_types            = ["Kerberos"]
      kerberos_ticket_encryption_type = ["RC4-HMAC", "AES-256"]
      channel_encryption_type         = ["AES-128-CCM", "AES-128-GCM"]
    }
  }
}

# Storage account with infrastructure encryption
module "storage_account_infra_encryption" {
  source = "../../../modules/azure/storage-account"

  name                = "infraencryptionstg"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  account_kind                      = "StorageV2"
  infrastructure_encryption_enabled = true

  # Note: Infrastructure encryption requires additional configuration in a production environment
}

# Storage account with SAS policy
module "storage_account_sas_policy" {
  source = "../../../modules/azure/storage-account"

  name                = "saspolicystg"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  sas_policy = {
    expiration_period = "P30D" # 30 days
    expiration_action = "Log"
  }
}