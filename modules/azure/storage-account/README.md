# Azure Storage Account Terraform Module

This module creates an Azure Storage Account with configurable options, including network rules, tags, and container creation.

> **Looking for a quick demo?** Jump to the [Quick Demo](#quick-demo) section for the simplest configuration.

## Features

- Create a storage account with customizable configuration
- Configure network rules for secure access
- Support for managed identity
- Custom blob properties configuration
- Container creation and management
- Supports all storage account types and replication options
- Static website hosting
- Customer managed key encryption
- Azure Files authentication
- Queue properties configuration
- CORS rules for services
- Immutable storage with versioning
- NFS v3 protocol support
- Shared Access Signature policies
- Infrastructure encryption
- Edge zone configuration
- Large file share capabilities

## Quick Demo

For a simple demonstration, you only need to specify these three required parameters:

```hcl
module "storage_account_demo" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/storage-account"

  name                = "mystorageaccount"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
}
```

That's it! This will create a standard storage account with reasonable defaults:
- Standard performance tier
- Locally redundant storage (LRS)
- StorageV2 account kind
- Hot access tier

### Minimal Configuration Guide

If you're just getting started or need a quick demo, focus on these parameters:

1. **Required parameters:**
   - `name`: The name of your storage account (must be globally unique)
   - `resource_group_name`: The name of an existing resource group
   - `location`: Azure region where the storage account will be created

2. **Commonly customized (but optional) parameters:**
   - `account_tier`: Performance tier ("Standard" or "Premium")
   - `account_replication_type`: Data redundancy type ("LRS", "GRS", etc.)
   - `tags`: Resource tags for organization

3. **Additional features:**
   - For container creation, use the `containers` parameter only when needed
   - All other parameters can be left at their defaults for most demo scenarios

## Usage

### Basic Storage Account

```hcl
module "storage_account" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/storage-account"

  name                = "mystorageaccount"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
  
  # Optional configuration with defaults
  account_tier             = "Standard"  # Optional: Performance tier
  account_replication_type = "LRS"       # Optional: Redundancy type
  account_kind             = "StorageV2" # Optional: Account kind
  access_tier              = "Hot"       # Optional: Access tier

  # Optional: Add tags for better organization
  tags = {
    environment = "production"
    owner       = "devops-team"
  }
}
```

### Storage Account with Network Rules

```hcl
module "storage_account_with_network_rules" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/storage-account"

  name                = "privatestorageaccount"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
  
  network_rules = {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = ["203.0.113.0/24"]
    virtual_network_subnet_ids = ["subnet-id-1", "subnet-id-2"]
    private_link_access = [
      {
        endpoint_resource_id = "resource-id"
      }
    ]
  }
}
```

### Storage Account with Containers

```hcl
module "storage_account_with_containers" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/storage-account"

  name                = "containerstorageaccount"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
  
  containers = {
    "data" = {
      access_type = "private"
    }
    "public" = {
      access_type = "blob"
    }
    "content" = {
      access_type = "container"
    }
  }
}
```

### Storage Account with Blob Properties

```hcl
module "storage_account_with_blob_properties" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/storage-account"

  name                = "blobstorageaccount"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
  
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
        allowed_methods    = ["GET", "POST"]
        allowed_origins    = ["https://example.com"]
        exposed_headers    = ["*"]
        max_age_in_seconds = 3600
      }
    ]
  }
}
```

### Storage Account with Static Website

```hcl
module "storage_account_with_static_website" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/storage-account"

  name                = "staticwebsiteaccount"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
  
  account_kind        = "StorageV2"
  
  static_website = {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}
```

### Storage Account with Customer Managed Keys

```hcl
module "storage_account_with_cmk" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/storage-account"

  name                = "cmkstorageaccount"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
  
  identity = {
    type = "SystemAssigned, UserAssigned"
    identity_ids = ["user-assigned-identity-id"]
  }
  
  customer_managed_key = {
    key_vault_key_id          = "key-vault-key-id"
    user_assigned_identity_id = "user-assigned-identity-id"
  }
}
```

### Storage Account with Azure Files Authentication

```hcl
module "storage_account_with_files_auth" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/storage-account"

  name                = "filesauthstorageaccount"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
  
  account_kind = "FileStorage"
  account_tier = "Premium"
  
  azure_files_authentication = {
    directory_type = "AD"
    active_directory = {
      domain_name         = "contoso.com"
      domain_guid         = "domain-guid"
      domain_sid          = "domain-sid"
      storage_sid         = "storage-sid"
      forest_name         = "forest-name"
      netbios_domain_name = "CONTOSO"
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| azurerm | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the storage account | `string` | n/a | yes (required) |
| resource_group_name | Name of the resource group | `string` | n/a | yes (required) |
| location | Azure location where the resource should be created | `string` | n/a | yes (required) |
| account_tier | Defines the Tier to use for this storage account (Standard or Premium) | `string` | `"Standard"` | no |
| account_replication_type | Defines the type of replication to use for this storage account | `string` | `"LRS"` | no |
| account_kind | Defines the Kind of account | `string` | `"StorageV2"` | no |
| access_tier | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts | `string` | `"Hot"` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| enable_https_traffic_only | Boolean flag which forces HTTPS if enabled (Deprecated: This setting is now enabled by default in newer Azure provider versions) | `bool` | `true` | no |
| min_tls_version | The minimum supported TLS version for the storage account | `string` | `"TLS1_2"` | no |
| is_hns_enabled | Is Hierarchical Namespace enabled? | `bool` | `false` | no |
| allow_nested_items_to_be_public | Allow or disallow public access to all blobs or containers | `bool` | `true` | no |
| shared_access_key_enabled | Indicates whether the storage account permits requests to be authorized with the account access key | `bool` | `true` | no |
| nfsv3_enabled | Is NFSv3 protocol enabled? | `bool` | `false` | no |
| large_file_share_enabled | Enable Large File Share | `bool` | `false` | no |
| infrastructure_encryption_enabled | Is infrastructure encryption enabled? | `bool` | `false` | no |
| cross_tenant_replication_enabled | Enable or disable cross tenant replication | `bool` | `true` | no |
| default_to_oauth_authentication | Default to Azure Active Directory authorization for data access | `bool` | `false` | no |
| edge_zone | Specifies the Edge Zone within the Azure Region | `string` | `null` | no |
| network_rules | Network rules to apply to the storage account | `object` | `null` | no |
| blob_properties | Blob properties for the storage account | `object` | `null` | no |
| static_website | Static website configuration for the storage account | `object` | `null` | no |
| queue_properties | Queue properties for the storage account | `object` | `null` | no |
| share_properties | Share properties for the storage account | `object` | `null` | no |
| identity | Identity block for the storage account | `object` | `null` | no |
| customer_managed_key | Customer Managed Key Encryption configuration | `object` | `null` | no |
| azure_files_authentication | Azure Files Authentication configuration | `object` | `null` | no |
| routing | Routing configuration for the storage account | `object` | `null` | no |
| immutability_policy | Immutability policy configuration | `object` | `null` | no |
| sas_policy | SAS policy configuration | `object` | `null` | no |
| containers | Map of containers to create | `map(object)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Storage Account |
| name | The name of the Storage Account |
| primary_access_key | The primary access key for the Storage Account |
| secondary_access_key | The secondary access key for the Storage Account |
| primary_blob_endpoint | The endpoint URL for blob storage in the primary location |
| primary_blob_host | The hostname with port if applicable for blob storage in the primary location |
| primary_connection_string | The connection string associated with the primary location |
| secondary_connection_string | The connection string associated with the secondary location |
| primary_dfs_endpoint | The endpoint URL for DFS storage in the primary location |
| primary_file_endpoint | The endpoint URL for file storage in the primary location |
| primary_queue_endpoint | The endpoint URL for queue storage in the primary location |
| primary_table_endpoint | The endpoint URL for table storage in the primary location |
| primary_web_endpoint | The endpoint URL for web storage in the primary location |
| secondary_blob_endpoint | The endpoint URL for blob storage in the secondary location |
| secondary_file_endpoint | The endpoint URL for file storage in the secondary location |
| secondary_queue_endpoint | The endpoint URL for queue storage in the secondary location |
| secondary_table_endpoint | The endpoint URL for table storage in the secondary location |
| secondary_web_endpoint | The endpoint URL for web storage in the secondary location |
| containers | Created storage containers |