[![Build Status](https://dev.azure.com/softveda/Hashicorp%20Demo/_apis/build/status/softveda.VaultDemo?branchName=main)](https://dev.azure.com/softveda/Hashicorp%20Demo/_build/latest?definitionId=8&branchName=main)

# Vault Kubernetes and Azure Demo

TodoApp is a web app written in C#/.Net Core 3 and build in Azure via DevOps pipeline. A Dockerfile is provided to build the Docker image which is pushed to an Azure Container Registry. Terraform is used to provision Azure services and the app is delpoyed to both an App Service (PAAS) and to an existing AKS Kubernetes cluster.

TodoExporter is a console app written in C#/.Net Core 3. It reads the Todo items created from TodoApp and exports it to a AWS S3 bucket. The app is manually deplpoyed to an Azure Linux VM.

---
## Project Files

- **src/TodoApp** - The TodoApp web app written in C#/.Net Core 3.
- **src/TodoExporter** - The TodoExporter console app written in C#/.Net Core 3.
- **deploy/templates** - This has all Azure DevOps pipeline yamls
- **deploy/azure** - This has all Azure Terraform modules and templates
- **deploy/kubernetes** - This has all Kubernetes manifests to host the TodoApp
- **deploy/vault** - Scripts to demo vault workflow for Kubernetes, Dynamic DB Secrets and Identity brokering across AWS.
