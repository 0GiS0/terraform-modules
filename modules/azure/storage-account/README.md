# Azure Storage Account Terraform Module

This module creates an Azure Storage Account with configurable options, including network rules, tags, and container creation.

## Features

- Create a storage account with customizable configuration
- Configure network rules for secure access
- Support for managed identity
- Custom blob properties configuration
- Container creation and management
- Supports all storage account types and replication options

## Usage

### Basic Storage Account

```hcl
module "storage_account" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/storage-account"

  name                = "mystorageaccount"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
  
  # Optional configuration with defaults
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

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
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| azurerm | >= 2.40.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.40.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the storage account | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure location where the resource should be created | `string` | n/a | yes |
| account_tier | Defines the Tier to use for this storage account (Standard or Premium) | `string` | `"Standard"` | no |
| account_replication_type | Defines the type of replication to use for this storage account | `string` | `"LRS"` | no |
| account_kind | Defines the Kind of account | `string` | `"StorageV2"` | no |
| access_tier | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts | `string` | `"Hot"` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| enable_https_traffic_only | Boolean flag which forces HTTPS if enabled | `bool` | `true` | no |
| min_tls_version | The minimum supported TLS version for the storage account | `string` | `"TLS1_2"` | no |
| is_hns_enabled | Is Hierarchical Namespace enabled? | `bool` | `false` | no |
| network_rules | Network rules to apply to the storage account | `object` | `null` | no |
| blob_properties | Blob properties for the storage account | `object` | `null` | no |
| identity | Identity block for the storage account | `object` | `null` | no |
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
| containers | Created storage containers |