variable "name" {
  description = "Name of the AKS cluster"
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

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster. If not specified, the name will be used."
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "default_node_pool" {
  description = "The default node pool configuration"
  type = object({
    name                = string
    node_count          = number
    vm_size             = string
    enable_auto_scaling = optional(bool, false)
    min_count           = optional(number, null)
    max_count           = optional(number, null)
    os_disk_size_gb     = optional(number, null)
    vnet_subnet_id      = optional(string, null)
    zones               = optional(list(string), null)
  })
  default = {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_D2_v2"
    enable_auto_scaling = false
  }
}

variable "network_profile" {
  description = "Network profile configuration"
  type = object({
    network_plugin    = string
    network_policy    = optional(string, null)
    load_balancer_sku = optional(string, "standard")
    outbound_type     = optional(string, "loadBalancer")
  })
  default = null
}