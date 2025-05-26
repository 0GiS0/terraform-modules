variable "name" {
  description = "Name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location where the resource should be created"
  type        = string
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account (Standard or Premium)"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "The account_tier must be either \"Standard\" or \"Premium\"."
  }
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "LRS"
  
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "The account_replication_type must be one of \"LRS\", \"GRS\", \"RAGRS\", \"ZRS\", \"GZRS\", \"RAGZRS\"."
  }
}

variable "account_kind" {
  description = "Defines the Kind of account (BlobStorage, BlockBlobStorage, FileStorage, Storage or StorageV2)"
  type        = string
  default     = "StorageV2"
  
  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "The account_kind must be one of \"BlobStorage\", \"BlockBlobStorage\", \"FileStorage\", \"Storage\", \"StorageV2\"."
  }
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts (Hot or Cool)"
  type        = string
  default     = "Hot"
  
  validation {
    condition     = contains(["Hot", "Cool"], var.access_tier)
    error_message = "The access_tier must be either \"Hot\" or \"Cool\"."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "enable_https_traffic_only" {
  description = "Boolean flag which forces HTTPS if enabled"
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account"
  type        = string
  default     = "TLS1_2"
}

variable "is_hns_enabled" {
  description = "Is Hierarchical Namespace enabled? This is required for Azure Data Lake Storage Gen 2"
  type        = bool
  default     = false
}

variable "network_rules" {
  description = "Network rules to apply to the storage account"
  type = object({
    default_action             = string
    bypass                     = list(string)
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "blob_properties" {
  description = "Blob properties for the storage account"
  type = object({
    container_delete_retention_policy = object({
      days = number
    })
    delete_retention_policy = object({
      days = number
    })
    versioning_enabled       = bool
    change_feed_enabled      = bool
    last_access_time_enabled = bool
  })
  default = null
}

variable "identity" {
  description = "Identity block for the storage account"
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = null
}

variable "containers" {
  description = "Map of containers to create"
  type = map(object({
    access_type = string
  }))
  default = null
}