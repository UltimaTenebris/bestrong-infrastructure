# BeStrong Infrastructure & Deployment

![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/helm-%230F1689.svg?style=for-the-badge&logo=helm&logoColor=white)

This repository contains the **Infrastructure as Code (IaC)** and **CI/CD Configuration** for the "BeStrong" API application.

It is designed to provision a production-ready Azure Kubernetes Service (AKS) cluster and implements a **Blue-Green Deployment Strategy** to ensure zero-downtime updates.

---

## Architecture Overview

* **Cloud Provider:** Microsoft Azure
* **Orchestrator:** Azure Kubernetes Service (AKS)
* **IaC Tool:** Terraform
* **Package Manager:** Helm
* **CI/CD:** GitHub Actions
* **Deployment Strategy:** Blue-Green (Team 1)

### Blue-Green Strategy
We utilize a traffic-switching approach:
1.  **Blue (Live):** The stable version currently serving user traffic.
2.  **Green (Idle):** The new version deployed alongside Blue for testing.
3.  **The Switch:** An Ingress configuration update instantly routes traffic from Blue to Green.

---

## Prerequisites

To run this project locally, you need:
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Terraform](https://www.terraform.io/downloads)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/)
* [Helm](https://helm.sh/docs/intro/install/)

---

## Getting Started

### 1. Provision Infrastructure (Terraform)
Initialize and apply the Terraform configuration to create the AKS cluster and ACR.

```bash
# Login to Azure
az login

# Initialize Terraform
cd terraform
terraform init

# Apply Configuration
terraform apply -var="resource_group_name=bestrong-rg" -var="location=East US"
