provider "azurerm" {
  features {}
}

# provider "kubernetes" {
#   host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
#   client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
#   client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
#   cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
# }

resource "azurerm_resource_group" "rg" {
  name     = "test-rg-bg"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}megacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}