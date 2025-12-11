provider "azurerm" {
features {}

subscription_id = "8618031d-ad43-42d5-b710-12eb173c5621"
tenant_id = "756dd590-85ca-48f4-89cb-f0753277d98c"

use_oidc = true
}

resource "azurerm_resource_group" "rg" {
name = "rg-devops-aks"
location = "West US 2"
}

resource "azurerm_container_registry" "acr" {
name = "devopsacr00123"
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location
sku = "Basic"
admin_enabled = false
}

resource "azurerm_kubernetes_cluster" "aks" {
name = "devops-aks"
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
dns_prefix = "devops-aks"

default_node_pool {
  name       = "nodepool1"
  node_count = 1
  vm_size    = "Standard_B2ms"
}


identity {
type = "SystemAssigned"
}
}

resource "azurerm_role_assignment" "aks_to_acr" {
principal_id = azurerm_kubernetes_cluster.aks.identity[0].principal_id
role_definition_name = "AcrPull"
scope = azurerm_container_registry.acr.id
}
