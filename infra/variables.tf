variable "resource_group_name" {
  type    = string
  default = "rg-devops-aks"
}

variable "location" {
  type    = string
  default = "West US 2"
}

variable "acr_name" {
  type    = string
  default = "devopsacr00123"
}

variable "aks_name" {
  type    = string
  default = "devops-aks"
}

variable "agent_pool_name" {
  type    = string
  default = "nodepool1"
}

variable "agent_node_count" {
  type    = number
  default = 1
}

variable "agent_vm_size" {
  type    = string
  default = "Standard_B2s_v2"
}
