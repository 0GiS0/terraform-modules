# Azure Storage Account Module Examples

This directory contains examples of how to use the Azure Storage Account module.

## Examples Included

1. **Basic Storage Account** - A simple storage account with minimal configuration
2. **Storage Account with Network Rules** - Demonstrates how to secure a storage account with network rules
3. **Storage Account with Containers** - Shows how to create a storage account with multiple containers
4. **Storage Account with Blob Properties** - Configures advanced blob properties like versioning and retention policies

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Clean up when done:
   ```bash
   terraform destroy
   ```

## Notes

- These examples create real resources in Azure, which may incur costs
- Make sure you have appropriate permissions to create these resources
- Remember to destroy the resources when you're done to avoid unnecessary charges