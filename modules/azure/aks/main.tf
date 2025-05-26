terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.this]
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix != null ? var.dns_prefix : var.name
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  default_node_pool {
    name                = var.default_node_pool.name
    node_count          = var.default_node_pool.node_count
    vm_size             = var.default_node_pool.vm_size
    enable_auto_scaling = var.default_node_pool.enable_auto_scaling
    min_count           = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.min_count : null
    max_count           = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.max_count : null
    os_disk_size_gb     = var.default_node_pool.os_disk_size_gb
    vnet_subnet_id      = var.default_node_pool.vnet_subnet_id
    zones               = var.default_node_pool.zones
  }

  identity {
    type = "SystemAssigned"
  }

  # Network profile
  dynamic "network_profile" {
    for_each = var.network_profile != null ? [var.network_profile] : []
    content {
      network_plugin    = network_profile.value.network_plugin
      network_policy    = lookup(network_profile.value, "network_policy", null)
      load_balancer_sku = lookup(network_profile.value, "load_balancer_sku", "standard")
      outbound_type     = lookup(network_profile.value, "outbound_type", "loadBalancer")
    }
  }
}