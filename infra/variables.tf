# Resource Group Name
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-devops-aks"
}

# Location
variable "location" {
  description = "Azure region"
  type        = string
  default     = "West US 2"
}

# ACR name (must be globally unique)
variable "acr_name" {
  description = "Azure Container Registry Name"
  type        = string
  default     = "devopsacr00123"
}

# AKS Cluster Name
variable "aks_name" {
  description = "Name of AKS Cluster"
  type        = string
  default     = "devops-aks"
}

# Node Pool Name
variable "agent_pool_name" {
  description = "Name of system node pool"
  type        = string
  default     = "nodepool1"
}

# Node Count
variable "agent_node_count" {
  description = "Initial node count"
  type        = number
  default     = 1
}

# VM Size (compatible with your subscription)
variable "agent_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s_v2"
}
