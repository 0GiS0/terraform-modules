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

# New variables for latest Azure Storage features

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow public access to all blobs or containers in the storage account"
  type        = bool
  default     = true
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key"
  type        = bool
  default     = true
}

variable "nfsv3_enabled" {
  description = "Is NFSv3 protocol enabled? This can only be true when account_tier is Premium and account_kind is BlockBlobStorage or FileStorage"
  type        = bool
  default     = false
}

variable "large_file_share_enabled" {
  description = "Enable Large File Share"
  type        = bool
  default     = false
}

variable "infrastructure_encryption_enabled" {
  description = "Is infrastructure encryption enabled? This can only be true when account_kind is StorageV2 or FileStorage"
  type        = bool
  default     = false
}

variable "cross_tenant_replication_enabled" {
  description = "Enable or disable cross tenant replication"
  type        = bool
  default     = true
}

variable "default_to_oauth_authentication" {
  description = "Default to Azure Active Directory authorization for data access"
  type        = bool
  default     = false
}

variable "edge_zone" {
  description = "Specifies the Edge Zone within the Azure Region where this Storage Account should exist"
  type        = string
  default     = null
}

variable "network_rules" {
  description = "Network rules to apply to the storage account"
  type = object({
    default_action             = string
    bypass                     = list(string)
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
    private_link_access = optional(list(object({
      endpoint_resource_id = string
      endpoint_tenant_id   = optional(string)
    })))
  })
  default = null
}

variable "blob_properties" {
  description = "Blob properties for the storage account"
  type = object({
    container_delete_retention_policy = optional(object({
      days = number
    }))
    delete_retention_policy = optional(object({
      days = number
    }))
    versioning_enabled       = optional(bool, false)
    change_feed_enabled      = optional(bool, false)
    last_access_time_enabled = optional(bool, false)
    cors_rule = optional(list(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    })))
    restore_policy = optional(object({
      days = number
    }))
  })
  default = null
}

variable "static_website" {
  description = "Static website configuration for the storage account"
  type = object({
    index_document     = optional(string)
    error_404_document = optional(string)
  })
  default = null
}

variable "queue_properties" {
  description = "Queue properties for the storage account"
  type = object({
    cors_rule = optional(list(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    })))
    logging = optional(object({
      delete                = bool
      read                  = bool
      write                 = bool
      version               = string
      retention_policy_days = optional(number)
    }))
    minute_metrics = optional(object({
      enabled               = bool
      version               = string
      include_apis          = optional(bool)
      retention_policy_days = optional(number)
    }))
    hour_metrics = optional(object({
      enabled               = bool
      version               = string
      include_apis          = optional(bool)
      retention_policy_days = optional(number)
    }))
  })
  default = null
}

variable "share_properties" {
  description = "Share properties for the storage account"
  type = object({
    cors_rule = optional(list(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    })))
    retention_policy = optional(object({
      days = optional(number, 7)
    }))
    smb = optional(object({
      versions                        = optional(list(string))
      authentication_types            = optional(list(string))
      kerberos_ticket_encryption_type = optional(list(string))
      channel_encryption_type         = optional(list(string))
      multichannel_enabled            = optional(bool)
    }))
  })
  default = null
}

variable "identity" {
  description = "Identity block for the storage account"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "customer_managed_key" {
  description = "Customer Managed Key Encryption configuration"
  type = object({
    key_vault_key_id          = string
    user_assigned_identity_id = optional(string)
  })
  default = null
}

variable "azure_files_authentication" {
  description = "Azure Files Authentication configuration"
  type = object({
    directory_type = string
    active_directory = optional(object({
      domain_name         = string
      domain_guid         = string
      domain_sid          = string
      storage_sid         = string
      forest_name         = optional(string)
      netbios_domain_name = optional(string)
    }))
  })
  default = null
}

variable "routing" {
  description = "Routing configuration for the storage account"
  type = object({
    publish_internet_endpoints  = optional(bool, false)
    publish_microsoft_endpoints = optional(bool, false)
    choice                      = optional(string, "MicrosoftRouting")
  })
  default = null
}

variable "immutability_policy" {
  description = "Immutability policy configuration"
  type = object({
    allow_protected_append_writes = bool
    state                         = string
    period_since_creation_in_days = number
  })
  default = null
}

variable "sas_policy" {
  description = "SAS policy configuration"
  type = object({
    expiration_period = string
    expiration_action = optional(string, "Log")
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