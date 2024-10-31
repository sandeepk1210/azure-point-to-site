resource_group_name = "Regroup_6f0zj6VVZaiwPPF7nwGD0j"

#Network
vnet_name           = "tooling-vnet"
default_subnet_name = "default-subnet"
gateway_subnet_name = "GatewaySubnet"
address_space       = ["10.0.0.0/16"]
default_subnet_cidr = "10.0.0.0/24"
gateway_subnet_cidr = "10.0.1.0/24"

#VM
admin_username = "adminuser"
vm_size        = "Standard_B2s"
vm_count       = 1

# Virtual Network Gateway
vpn_gateway_name = "app-gateway"
gateway_sku      = "VpnGw2" # Options: Basic, VpnGw1, VpnGw2, etc.
p2s_address_pool = ["172.16.0.0/24"]
