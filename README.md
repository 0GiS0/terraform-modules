# Terraform Modules

A collection of reusable Terraform modules for various cloud providers.

## Available Modules

### Azure

- [Storage Account](./modules/azure/storage-account/README.md) - Create and manage Azure Storage Accounts with configurable options.

## Usage

To use a module in your Terraform configuration, add the following:

```hcl
module "module_name" {
  source = "github.com/0GiS0/terraform-modules//modules/provider/service"
  
  # Module-specific inputs
}
```

See the README.md in each module directory for specific usage instructions and available options.