resource "azurerm_dns_zone" "bestrong" {
  name                = "bestrong.pp.ua"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_a_record" "root" {
  name                = "@"
  zone_name           = azurerm_dns_zone.bestrong.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 60
  records             = [azurerm_public_ip.appgw_ip.ip_address]
}

