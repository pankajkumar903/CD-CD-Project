# Terraform Azure Infrastructure Deployment (RG + AKS + ACR)

This repo contains Terraform code to deploy Azure resources using CI/CD.  
The infra folder includes the Terraform configuration, and a YAML pipeline automates deployment.

## Folder Structure
infra/
  main.tf
  variables.tf
  outputs.tf

azure-pipelines.yaml   (or ci-cd.yaml)

## What This Deploys
- Azure Resource Group
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Remote backend using Azure Blob Storage for state management

## How It Works
1. Terraform code is stored in the infra folder.
2. Pipeline (YAML file) runs terraform init, plan, and apply.
3. State is stored in Azure Blob Storage with locking and versioning.
4. AKS is connected with ACR for pulling images.
5. Deployment is fully automated through CI/CD.

## CI/CD Pipeline Steps (YAML)
- Checkout code
- Install Terraform
- terraform init (connect backend)
- terraform plan (preview changes)
- terraform apply (deploy infra)

## Usage
1. Update variables in infra/variables.tf or tfvars file.
2. Push changes to trigger the CI/CD pipeline.
3. Pipeline deploys RG, ACR, and AKS automatically.

