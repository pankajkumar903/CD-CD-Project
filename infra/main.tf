provider "azurerm" {
  features {}

  subscription_id = "8618031d-ad43-42d5-b710-12eb173c5621"
  tenant_id       = "756dd590-85ca-48f4-89cb-f0753277d98c"

  use_oidc = true
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# --------------------------------------------------------------------
# 1. SAFE Attempt to lookup existing ACR (will NOT stop plan/apply)
# --------------------------------------------------------------------
data "azurerm_container_registry" "existing" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name

  lifecycle {
    postcondition {
      condition     = true
      error_message = "Ignoring ACR lookup failure"
    }
  }
}

# --------------------------------------------------------------------
# 2. Create ACR ONLY if it does NOT exist
# --------------------------------------------------------------------
resource "azurerm_container_registry" "acr" {
  count               = can(data.azurerm_container_registry.existing.id) ? 0 : 1
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
}

# --------------------------------------------------------------------
# 3. Determine final ACR (existing OR newly created)
# --------------------------------------------------------------------
locals {
  acr_id           = can(data.azurerm_container_registry.existing.id) ? data.azurerm_container_registry.existing.id : azurerm_container_registry.acr[0].id
  acr_login_server = can(data.azurerm_container_registry.existing.login_server) ? data.azurerm_container_registry.existing.login_server : azurerm_container_registry.acr[0].login_server
}

# --------------------------------------------------------------------
# 4. AKS Cluster
# --------------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_name

  default_node_pool {
    name       = var.agent_pool_name
    node_count = var.agent_node_count
    vm_size    = var.agent_vm_size
  }

  identity {
    type = "SystemAssigned"
  }
}

# --------------------------------------------------------------------
# 5. Allow AKS to pull images from ACR
# --------------------------------------------------------------------
resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = local.acr_id
}
