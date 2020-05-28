output "rglocation" {
  value = azurerm_resource_group.rg1.location
}


output "rgname" {
  value = azurerm_resource_group.rg1.name
}

output "subnetId" {
	value = azurerm_subnet.subnet1.id

}
