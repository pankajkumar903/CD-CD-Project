# Name of the Resource Group
variable "resource_group_name" {
  description = "Name of the resource group where AKS and ACR will be deployed"
  type        = string
  default     = "rg-devops-aks"
}

# Azure region for all resources
variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "West US 2"
}

# Name of the Azure Container Registry (ACR)
variable "acr_name" {
  description = "Name of the Azure Container Registry. Must be globally unique"
  type        = string
  default     = "devopsacr00123"
}

# AKS Cluster Name
variable "aks_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "devops-aks"
}

# AKS Node Pool Settings
variable "agent_pool_name" {
  description = "Name of the AKS node pool"
  type        = string
  default     = "nodepool1"
}

variable "agent_vm_size" {
  description = "VM size for AKS node pool"
  type        = string
  default     = "Standard_B2s_v2"   # compatible with your subscription
}

variable "agent_node_count" {
  description = "Number of nodes in AKS node pool"
  type        = number
  default     = 1
}
