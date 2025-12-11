terraform {
  backend "azurerm" {
    resource_group_name   = "tfstate-global-rg"
    storage_account_name  = "pankajtfstateprod123"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
