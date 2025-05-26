# Azure Kubernetes Service (AKS) Terraform Module

This module creates an Azure Kubernetes Service (AKS) cluster with configurable options for node pools and networking.

> **Looking for a quick demo?** Jump to the [Quick Demo](#quick-demo) section for the simplest configuration.

## Features

- Creates a basic AKS cluster in Azure
- Configurable default node pool
- System-assigned managed identity for cluster authentication
- Optional network profile configuration
- Outputs the cluster's connection information

## Quick Demo

For a simple demonstration, you only need to specify these three required parameters:

```hcl
module "aks_demo" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/aks"

  name                = "my-aks-cluster"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
}
```

That's it! This will create a standard AKS cluster with reasonable defaults:
- A default node pool with a single Standard_D2_v2 node
- System-assigned managed identity
- Default network configuration

### Minimal Configuration Guide

If you're just getting started or need a quick demo, focus on these parameters:

1. **Required parameters:**
   - `name`: The name of your AKS cluster
   - `resource_group_name`: The name of an existing resource group
   - `location`: Azure region where the AKS cluster will be created

2. **Commonly customized (but optional) parameters:**
   - `default_node_pool`: Configuration for the default node pool (size, count, etc.)
   - `kubernetes_version`: The version of Kubernetes to use
   - `tags`: Resource tags for organization

3. **Additional features:**
   - For network configuration, use the `network_profile` parameter only when needed
   - All other parameters can be left at their defaults for most demo scenarios

## Usage

### Basic AKS Cluster

```hcl
module "aks_basic" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/aks"

  name                = "my-aks-cluster"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
  kubernetes_version  = "1.25.5"
  
  # Optional: Configure the default node pool
  default_node_pool = {
    name                = "default"
    node_count          = 2
    vm_size             = "Standard_D2_v2"
    os_disk_size_gb     = 30
    enable_auto_scaling = false
  }
  
  # Optional: Add tags for better organization
  tags = {
    environment = "production"
    owner       = "devops-team"
  }
}
```

### AKS Cluster with Autoscaling

```hcl
module "aks_with_autoscaling" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/aks"

  name                = "aks-autoscaling"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
  
  default_node_pool = {
    name                = "default"
    vm_size             = "Standard_D2_v2"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 5
  }
}
```

### AKS Cluster with Custom Networking

```hcl
module "aks_with_networking" {
  source = "github.com/0GiS0/terraform-modules//modules/azure/aks"

  name                = "aks-custom-network"
  resource_group_name = "my-resource-group"
  location            = "westeurope"
  
  default_node_pool = {
    name           = "default"
    node_count     = 3
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = "subnet-id" # Replace with your subnet ID
  }
  
  network_profile = {
    network_plugin = "azure"
    network_policy = "calico"
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
| name | Name of the AKS cluster | `string` | n/a | yes (required) |
| resource_group_name | Name of the resource group | `string` | n/a | yes (required) |
| location | Azure location where the resource should be created | `string` | n/a | yes (required) |
| dns_prefix | DNS prefix specified when creating the managed cluster | `string` | `null` | no |
| kubernetes_version | Version of Kubernetes specified when creating the AKS managed cluster | `string` | `null` | no |
| default_node_pool | The default node pool configuration | `object` | Default configuration | no |
| network_profile | Network profile configuration | `object` | `null` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Kubernetes Managed Cluster |
| name | The name of the Kubernetes Managed Cluster |
| kube_config_raw | Raw Kubernetes config to be used by kubectl and other compatible tools |
| kube_config | Kubernetes configuration |
| host | The Kubernetes cluster server host |
| client_certificate | Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster |
| client_key | Base64 encoded private key used by clients to authenticate to the Kubernetes cluster |
| cluster_ca_certificate | Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster |
| kubernetes_version | The version of Kubernetes used on the managed Kubernetes Cluster |
| node_resource_group | The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster |
| fqdn | The FQDN of the Azure Kubernetes Managed Cluster |