variable "resource_group_name" {
  description = "Name of the resource group to use or create"
  type        = string
  default     = "rg-devops-aks"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "West US 2"
}

variable "acr_name" {
  description = "Azure Container Registry name (must be globally unique)"
  type        = string
  default     = "devopsacr00123"
}

variable "aks_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "devops-aks"
}

variable "agent_pool_name" {
  description = "AKS default node pool name"
  type        = string
  default     = "nodepool1"
}

variable "agent_node_count" {
  description = "Number of nodes in AKS node pool"
  type        = number
  default     = 1
}

variable "agent_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s_v2"
}
