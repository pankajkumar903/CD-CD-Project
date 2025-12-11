output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_kubelet_identity" {
  value = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "acr_name" {
  value = var.acr_name
}

output "acr_id" {
  value = local.acr_id
}

output "acr_login_server" {
  value = local.acr_login_server
}
