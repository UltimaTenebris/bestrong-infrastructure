resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.prefix

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = "Standard_B2ps_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  network_profile {
    network_plugin = "azure"        # Azure CNI
    service_cidr   = "10.96.0.0/12" # стандартний для AKS
    dns_service_ip = "10.96.0.10"   # всередині service_cidr
  }

  identity {
    type = "SystemAssigned"
  }

  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.agw.id
  }

  tags = {
    environment = "test"
  }
}

resource "azurerm_role_assignment" "certmgr_dns" {
  scope                = azurerm_dns_zone.bestrong.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}