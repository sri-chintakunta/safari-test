# This configuration uses the 'null' provider, which is perfect for testing
# Terraform plan execution without requiring credentials for AWS, Azure, GCP, etc.

# 1. Terraform Block (Required Provider Definition)
terraform {
  required_providers {
    # We require the hashicorp/null provider
    # It must be version 3.0 or higher
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
  }
}

# 2. Provider Configuration (Tells Terraform how to interact with the 'null' provider)
# This block is required, even though the null provider doesn't need configuration parameters.
provider "null" {}

# 3. Resource Block (The actual resource to be created)
# The null_resource is a no-op resource that simply exists.
# This ensures that 'terraform plan' shows a resource will be added.
resource "null_resource" "quick_test_resource" {
  # This triggers a rebuild only if this timestamp changes.
  # For the initial run, it will show as an Add operation.
  triggers = {
    date_and_time = timestamp()
  }

  # The local-exec provisioner is not run during 'terraform plan',
  # but is often used with null resources to signal success or run local scripts.
  provisioner "local-exec" {
    command = "echo 'Terraform apply would run this command, but the plan passed!'"
  }
}

# 4. Optional: An output value to confirm successful definition
output "plan_status" {
  value = "The null_resource has been successfully defined for planning."
}