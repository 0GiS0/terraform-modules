output "basic_aks_id" {
  description = "The ID of the basic AKS cluster"
  value       = module.aks_basic.id
}

output "basic_aks_name" {
  description = "The name of the basic AKS cluster"
  value       = module.aks_basic.name
}

output "basic_aks_fqdn" {
  description = "The FQDN of the basic AKS cluster"
  value       = module.aks_basic.fqdn
}

output "autoscaling_aks_id" {
  description = "The ID of the AKS cluster with autoscaling"
  value       = module.aks_autoscaling.id
}

output "autoscaling_aks_node_resource_group" {
  description = "The node resource group of the AKS cluster with autoscaling"
  value       = module.aks_autoscaling.node_resource_group
}

output "network_aks_id" {
  description = "The ID of the AKS cluster with custom network profile"
  value       = module.aks_network_profile.id
}

output "network_aks_kubernetes_version" {
  description = "The Kubernetes version of the AKS cluster with custom network profile"
  value       = module.aks_network_profile.kubernetes_version
}