[![Build Status](https://dev.azure.com/softveda/Hashicorp%20Demo/_apis/build/status/softveda.VaultDemo?branchName=main)](https://dev.azure.com/softveda/Hashicorp%20Demo/_build/latest?definitionId=8&branchName=main)

# Vault Kubernetes and Azure Demo

TodoApp is a web app written in C#/.Net Core 3 and build in Azure via DevOps pipeline. A Dockerfile is provided to build the Docker image which is pushed to an Azure Container Registry. Terraform is used to provision Azure services and the app is deployed to both an App Service (PAAS) and to an existing AKS Kubernetes cluster.

TodoExporter is a console app written in C#/.Net Core 3. It reads the Todo items created from TodoApp and exports it to a AWS S3 bucket. The app is manually deployed to an Azure Linux VM (Binaries uploaded to a storage container from dev laptop and downloaded to the VM using azcopy). 

It demonstrates the following Vault workflows
- Authenticate to Vault from the VM using Azure Managed Identity and get a token
- Get dynamic SQL Database secrets from Vault
- Get dynamic AWS IAM programmatic user access from Vault

---
## Project Files

- **src/TodoApp** - The TodoApp web app written in C#/.Net Core 3.
- **src/TodoExporter** - The TodoExporter console app written in C#/.Net Core 3.
- **deploy/templates** - This has all Azure DevOps pipeline yamls
- **deploy/azure** - This has all Azure Terraform modules and templates
- **deploy/kubernetes** - This has all Kubernetes manifests to host the TodoApp
- **deploy/vault** - Scripts to demo vault workflow for Kubernetes, Dynamic DB Secrets and Identity brokering across AWS.
- **demoscripts** - The scripts to configure kubernetes for vault injector is in scrips 01 - 04. The scripts to configure Dynamic SQL and AWS secrets with Azure auth is in 05 - 08.
