# Azure Storage Account Module Examples

This directory contains examples of how to use the Azure Storage Account module.

## Examples Included

1. **Basic Storage Account** - A simple storage account with minimal configuration
2. **Storage Account with Network Rules** - Demonstrates how to secure a storage account with network rules
3. **Storage Account with Containers** - Shows how to create a storage account with multiple containers
4. **Storage Account with Blob Properties** - Configures advanced blob properties like versioning and retention policies
5. **Storage Account with Static Website** - Configures a storage account for static website hosting
6. **Storage Account with Queue Properties** - Demonstrates queue configuration with logging and CORS rules
7. **Storage Account with Share Properties** - Shows how to configure Azure File Shares with SMB settings
8. **Storage Account with Infrastructure Encryption** - Enables double encryption for data at rest
9. **Storage Account with SAS Policy** - Configures Shared Access Signature policies

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
- Some features like Customer Managed Keys require additional resources like Key Vault and managed identities
- Infrastructure encryption and other advanced features might have specific requirements for the storage account type and region