# Azure Kubernetes Service (AKS) Terraform Module

This module creates an Azure Kubernetes Service (AKS) cluster with configurable options for node pools and networking.

## Features

- Creates a basic AKS cluster in Azure
- Configurable default node pool
- System-assigned managed identity for cluster authentication
- Optional network profile configuration
- Outputs the cluster's connection information

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