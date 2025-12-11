provider "azurerm" {
  features {}

  subscription_id = "8618031d-ad43-42d5-b710-12eb173c5621"
  tenant_id       = "756dd590-85ca-48f4-89cb-f0753277d98c"

  use_oidc = true
}

variable "acr_name" {
  default = "devopsacr00123"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-aks"
  location = "West US 2"
}

# --------------------------------------------------------------------
# 1. Try to read existing ACR (safe lookup)
# --------------------------------------------------------------------
data "azurerm_container_registry" "existing" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = []
}

# --------------------------------------------------------------------
# 2. Create ACR only if it does NOT already exist
# --------------------------------------------------------------------
resource "azurerm_container_registry" "acr" {
  count               = try(data.azurerm_container_registry.existing.id, null) == null ? 1 : 0
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

# --------------------------------------------------------------------
# 3. Select ACR ID dynamically (existing or new)
# --------------------------------------------------------------------
locals {
  acr_id           = try(data.azurerm_container_registry.existing.id, azurerm_container_registry.acr[0].id)
  acr_login_server = try(data.azurerm_container_registry.existing.login_server, azurerm_container_registry.acr[0].login_server)
}

# --------------------------------------------------------------------
# 4. AKS Cluster (correct VM size)
# --------------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "devops-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "devops-aks"

  default_node_pool {
    name       = "nodepool1"
    node_count = 1
    vm_size    = "Standard_B2s_v2"   # Supported in your subscription
  }

  identity {
    type = "SystemAssigned"
  }
}

# --------------------------------------------------------------------
# 5. Role assignment (AKS → ACR)
# --------------------------------------------------------------------
resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = local.acr_id
}
