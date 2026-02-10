# # Публічний IP для App Gateway
# resource "azurerm_public_ip" "appgw_ip" {
#   name                = "bestrong-appgw-ip"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }


# # Application Gateway
# resource "azurerm_application_gateway" "agw" {
#   name                = "bestrong-appgw"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   sku {
#     name     = "Standard_v2"
#     tier     = "Standard_v2"
#     capacity = 1
#   }

#   gateway_ip_configuration {
#     name      = "appgw-ipcfg"
#     subnet_id = azurerm_subnet.agic_subnet.id
#   }

#   frontend_ip_configuration {
#     name                 = "public"
#     public_ip_address_id = azurerm_public_ip.appgw_ip.id
#   }

#   # --- Frontend Ports ---
#   frontend_port {
#     name = "http"
#     port = 80
#   }

#   frontend_port {
#     name = "https"
#     port = 443
#   }

#   # --- SSL Policy ---
#   ssl_policy {
#     policy_type = "Predefined"
#     policy_name = "AppGwSslPolicy20170401S"
#   }

#   # --- SSL Certificate (якщо HTTPS потрібен) ---
#   #  ssl_certificate {
#   #    name     = "ssl-cert"
#   #    data     = filebase64("path/to/your/certificate.pfx")
#   #    password = "your_certificate_password"
#   #  }

#   # --- Backend ---
#   backend_address_pool {
#     name = "backend-pool"
#   }

#   backend_http_settings {
#     name                  = "http-settings"
#     cookie_based_affinity = "Disabled"
#     port                  = 80
#     protocol              = "Http"
#     request_timeout       = 20
#   }

#   backend_http_settings {
#     name                  = "https-settings"
#     cookie_based_affinity = "Disabled"
#     port                  = 443
#     protocol              = "Https"
#     request_timeout       = 20
#   }

#   # --- Listeners ---
#   http_listener {
#     name                           = "http-listener"
#     frontend_ip_configuration_name = "public"
#     frontend_port_name             = "http"
#     protocol                       = "Http"
#   }

#   #  http_listener {
#   #    name                           = "https-listener"
#   #    frontend_ip_configuration_name = "public"
#   #    frontend_port_name             = "https"
#   #    protocol                       = "Https"
#   #    ssl_certificate_name           = "ssl-cert"
#   #  }

#   # --- Request Routing Rules ---
#   request_routing_rule {
#     name                       = "http-routing-rule"
#     rule_type                  = "Basic"
#     http_listener_name         = "http-listener"
#     backend_address_pool_name  = "backend-pool"
#     backend_http_settings_name = "http-settings"
#     priority                   = 100
#   }

#   #  request_routing_rule {
#   #    name                       = "https-routing-rule"
#   #    rule_type                  = "Basic"
#   #    http_listener_name          = "https-listener"
#   #    backend_address_pool_name   = "backend-pool"
#   #    backend_http_settings_name  = "https-settings"
#   #    priority                   = 200
#   #  }
# }
