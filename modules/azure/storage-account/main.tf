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
  
  # Enable HTTPS traffic only
  enable_https_traffic_only = var.enable_https_traffic_only
  
  # Hierarchical namespace
  is_hns_enabled = var.is_hns_enabled
  
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
}

# Create containers if specified
resource "azurerm_storage_container" "containers" {
  for_each = var.containers != null ? var.containers : {}
  
  name                  = each.key
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = each.value.access_type
}