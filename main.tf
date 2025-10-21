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
# By setting count to 1000, the plan will now show 1000 resources to be added,
# resulting in a very long plan output.
resource "null_resource" "large_test_set" {
  # Set count to 1000 to drastically increase the size of the plan output
  count = 1000
  
  # This triggers a rebuild only if this timestamp changes.
  triggers = {
    date_and_time = timestamp()
  }

  # The local-exec provisioner is not run during 'terraform plan',
  # but is often used with null resources to signal success or run local scripts.
  provisioner "local-exec" {
    command = "echo 'Resource instance ${count.index + 1} of 1000 planned.'"
  }
}

# 4. Optional: An output value to confirm successful definition
output "plan_status" {
  value = "The large_test_set resource with count=1000 has been defined."
}
