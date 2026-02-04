terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }

  backend "azurerm" {
    resource_group_name  = "BeStrongTeam01"
    storage_account_name = "bestrongtfstate123"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

