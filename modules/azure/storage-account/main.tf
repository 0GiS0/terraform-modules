terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.this]
    }
  }
}


resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  access_tier              = var.access_tier
  tags                     = var.tags
  min_tls_version          = var.min_tls_version

  # Hierarchical namespace
  is_hns_enabled = var.is_hns_enabled

  # Additional latest settings
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  shared_access_key_enabled         = var.shared_access_key_enabled
  nfsv3_enabled                     = var.nfsv3_enabled
  large_file_share_enabled          = var.large_file_share_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  edge_zone                         = var.edge_zone

  # Blob properties
  dynamic "blob_properties" {
    for_each = var.blob_properties != null ? [var.blob_properties] : []
    content {
      dynamic "container_delete_retention_policy" {
        for_each = blob_properties.value.container_delete_retention_policy != null ? [blob_properties.value.container_delete_retention_policy] : []
        content {
          days = container_delete_retention_policy.value.days
        }
      }

      dynamic "delete_retention_policy" {
        for_each = blob_properties.value.delete_retention_policy != null ? [blob_properties.value.delete_retention_policy] : []
        content {
          days = delete_retention_policy.value.days
        }
      }

      versioning_enabled       = lookup(blob_properties.value, "versioning_enabled", false)
      change_feed_enabled      = lookup(blob_properties.value, "change_feed_enabled", false)
      last_access_time_enabled = lookup(blob_properties.value, "last_access_time_enabled", false)

      # Latest blob property settings
      dynamic "cors_rule" {
        for_each = lookup(blob_properties.value, "cors_rule", [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "restore_policy" {
        for_each = lookup(blob_properties.value, "restore_policy", null) != null ? [blob_properties.value.restore_policy] : []
        content {
          days = restore_policy.value.days
        }
      }
    }
  }

  # Static website configuration
  dynamic "static_website" {
    for_each = var.static_website != null ? [var.static_website] : []
    content {
      index_document     = lookup(static_website.value, "index_document", null)
      error_404_document = lookup(static_website.value, "error_404_document", null)
    }
  }

  # Queue properties
  dynamic "queue_properties" {
    for_each = var.queue_properties != null ? [var.queue_properties] : []
    content {
      dynamic "cors_rule" {
        for_each = lookup(queue_properties.value, "cors_rule", [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = lookup(queue_properties.value, "logging", null) != null ? [queue_properties.value.logging] : []
        content {
          delete                = logging.value.delete
          read                  = logging.value.read
          write                 = logging.value.write
          version               = logging.value.version
          retention_policy_days = lookup(logging.value, "retention_policy_days", null)
        }
      }

      dynamic "minute_metrics" {
        for_each = lookup(queue_properties.value, "minute_metrics", null) != null ? [queue_properties.value.minute_metrics] : []
        content {
          enabled               = minute_metrics.value.enabled
          version               = minute_metrics.value.version
          include_apis          = lookup(minute_metrics.value, "include_apis", null)
          retention_policy_days = lookup(minute_metrics.value, "retention_policy_days", null)
        }
      }

      dynamic "hour_metrics" {
        for_each = lookup(queue_properties.value, "hour_metrics", null) != null ? [queue_properties.value.hour_metrics] : []
        content {
          enabled               = hour_metrics.value.enabled
          version               = hour_metrics.value.version
          include_apis          = lookup(hour_metrics.value, "include_apis", null)
          retention_policy_days = lookup(hour_metrics.value, "retention_policy_days", null)
        }
      }
    }
  }

  # Share properties
  dynamic "share_properties" {
    for_each = var.share_properties != null ? [var.share_properties] : []
    content {
      dynamic "cors_rule" {
        for_each = lookup(share_properties.value, "cors_rule", [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = lookup(share_properties.value, "retention_policy", null) != null ? [share_properties.value.retention_policy] : []
        content {
          days = lookup(retention_policy.value, "days", 7)
        }
      }

      dynamic "smb" {
        for_each = lookup(share_properties.value, "smb", null) != null ? [share_properties.value.smb] : []
        content {
          versions                        = lookup(smb.value, "versions", null)
          authentication_types            = lookup(smb.value, "authentication_types", null)
          kerberos_ticket_encryption_type = lookup(smb.value, "kerberos_ticket_encryption_type", null)
          channel_encryption_type         = lookup(smb.value, "channel_encryption_type", null)
          multichannel_enabled            = lookup(smb.value, "multichannel_enabled", null)
        }
      }
    }
  }

  # Network rules
  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids

      # Latest network rule properties
      dynamic "private_link_access" {
        for_each = lookup(network_rules.value, "private_link_access", [])
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = lookup(private_link_access.value, "endpoint_tenant_id", null)
        }
      }
    }
  }

  # Identity
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  # Customer managed keys
  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? [var.customer_managed_key] : []
    content {
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      user_assigned_identity_id = lookup(customer_managed_key.value, "user_assigned_identity_id", null)
    }
  }

  # Azure Files Authentication
  dynamic "azure_files_authentication" {
    for_each = var.azure_files_authentication != null ? [var.azure_files_authentication] : []
    content {
      directory_type = azure_files_authentication.value.directory_type

      dynamic "active_directory" {
        for_each = lookup(azure_files_authentication.value, "active_directory", null) != null ? [azure_files_authentication.value.active_directory] : []
        content {
          domain_name         = active_directory.value.domain_name
          domain_guid         = active_directory.value.domain_guid
          domain_sid          = active_directory.value.domain_sid
          storage_sid         = active_directory.value.storage_sid
          forest_name         = lookup(active_directory.value, "forest_name", null)
          netbios_domain_name = lookup(active_directory.value, "netbios_domain_name", null)
        }
      }
    }
  }

  # Routing
  dynamic "routing" {
    for_each = var.routing != null ? [var.routing] : []
    content {
      publish_internet_endpoints  = lookup(routing.value, "publish_internet_endpoints", false)
      publish_microsoft_endpoints = lookup(routing.value, "publish_microsoft_endpoints", false)
      choice                      = lookup(routing.value, "choice", "MicrosoftRouting")
    }
  }

  # Immutable storage with versioning
  dynamic "immutability_policy" {
    for_each = var.immutability_policy != null ? [var.immutability_policy] : []
    content {
      allow_protected_append_writes = immutability_policy.value.allow_protected_append_writes
      state                         = immutability_policy.value.state
      period_since_creation_in_days = immutability_policy.value.period_since_creation_in_days
    }
  }

  # SAS policies
  dynamic "sas_policy" {
    for_each = var.sas_policy != null ? [var.sas_policy] : []
    content {
      expiration_period = sas_policy.value.expiration_period
      expiration_action = lookup(sas_policy.value, "expiration_action", "Log")
    }
  }
}

# Create containers if specified
resource "azurerm_storage_container" "containers" {
  for_each = var.containers != null ? var.containers : {}

  name                  = each.key
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = each.value.access_type
}
