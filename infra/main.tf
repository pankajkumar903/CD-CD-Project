provider "azurerm" {
  features {}

  subscription_id = "8618031d-ad43-42d5-b710-12eb173c5621"
  tenant_id       = "756dd590-85ca-48f4-89cb-f0753277d98c"

  use_oidc = true
}

# --------------------------------------------------------------------
# 0. SAFE lookup existing Resource Group (no errors if missing)
# --------------------------------------------------------------------
data "azurerm_resource_group" "existing_rg" {
  name = var.resource_group_name

  # This data source will throw error if RG doesn't exist.
  # try() will catch it in locals so we don't need lifecycle.
}

# --------------------------------------------------------------------
# 1. CREATE RG only if it does NOT exist
# --------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  count    = try(data.azurerm_resource_group.existing_rg.name, "") == "" ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

# Compute final RG name (existing OR newly created)
locals {
  final_rg_name = try(data.azurerm_resource_group.existing_rg.name, azurerm_resource_group.rg[0].name)
}

# --------------------------------------------------------------------
# 2. SAFE lookup existing ACR
# --------------------------------------------------------------------
data "azurerm_container_registry" "existing" {
  name                = var.acr_name
  resource_group_name = local.final_rg_name
}

# --------------------------------------------------------------------
# 3. CREATE ACR only if NOT existing
# --------------------------------------------------------------------
resource "azurerm_container_registry" "acr" {
  count               = try(data.azurerm_container_registry.existing.id, "") == "" ? 1 : 0
  name                = var.acr_name
  resource_group_name = local.final_rg_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
}

# ACR final ID and login server
locals {
  acr_id           = try(data.azurerm_container_registry.existing.id, azurerm_container_registry.acr[0].id)
  acr_login_server = try(data.azurerm_container_registry.existing.login_server, azurerm_container_registry.acr[0].login_server)
}

# --------------------------------------------------------------------
# 4. AKS Cluster
# --------------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = local.final_rg_name
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
# 5. Allow AKS to pull from ACR
# --------------------------------------------------------------------
resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = local.acr_id
}
