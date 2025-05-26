output "basic_storage_account_id" {
  description = "The ID of the basic storage account"
  value       = module.storage_account_basic.id
}

output "basic_storage_account_name" {
  description = "The name of the basic storage account"
  value       = module.storage_account_basic.name
}

output "basic_storage_account_primary_blob_endpoint" {
  description = "The endpoint URL for blob storage in the primary location"
  value       = module.storage_account_basic.primary_blob_endpoint
}

output "network_rules_storage_account_id" {
  description = "The ID of the storage account with network rules"
  value       = module.storage_account_network_rules.id
}

output "container_storage_account_containers" {
  description = "Created storage containers"
  value       = module.storage_account_containers.containers
}

output "blob_properties_storage_account_id" {
  description = "The ID of the storage account with blob properties"
  value       = module.storage_account_blob_properties.id
}