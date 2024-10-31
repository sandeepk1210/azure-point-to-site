# Azure Point-to-site VPN

Azure Point-to-Site (P2S) VPN is a secure, private connection option for connecting individual devices (like a laptop or desktop) to an Azure virtual network (VNet) over the internet. It’s particularly useful when only a few users need to access resources on the Azure network, as opposed to Site-to-Site VPN, which connects entire networks.

# Supported Protocols

Azure P2S VPN supports multiple VPN protocols:

- Secure Socket Tunneling Protocol (SSTP): Works well in environments where other protocols might be blocked, as it uses HTTPS (TCP port 443).
- IKEv2: Offers reliable connectivity on devices that support it, such as Windows, macOS, and iOS.
- OpenVPN: An open-source VPN protocol compatible with multiple platforms, including Linux and macOS, and allows for multi-factor authentication.

# Setup Process Overview

1. Create a Virtual Network Gateway: This serves as the VPN endpoint in Azure.
   It is created in VNet as a GatewaySubnet.  
   The gateway subnet is used to host gateway VMs and services. (This is managed service, as compared to managing a VM and installing, configuring VPN software and manage infra)
   No other VM must be deployed to the gateway subnet
   The VMs in this gateway subnet are configured with the required VPN gateway settings.

2. Configure Point-to-Site VPN: Define the address pool, DNS server, and VPN protocols.

3. Client Configuration: Generate VPN client configuration files for users to install on their devices.
VPN Client will be responsible for establishing point-to-site VPN connection

4. Authentication: Configure client authentication method (certificate-based, Azure AD, or RADIUS).

5. To set up Point-to-Site (P2S) VPN connections in Azure, you need to generate client and root certificates (already generated as part of code). Then install the required VPN client, which once installed on your or client local machine will establish the private connection.

If you’re using a Bash environment, OpenSSL can be used to create and export certificates.

AzureRootCert.cer - Root certificate (public key) for Azure. - Note this is already done as part of terraform code.
AzureClientCert.cer - Client certificate (public key).
AzureClientCert.pfx - Client certificate (private key).

The AzureRootCert.cer should be uploaded to the Azure VPN gateway configuration, while the AzureClientCert.pfx file is used to configure the client VPN connections.


a. Generate the Root Certificate:

bash
openssl req -x509 -newkey rsa:2048 -sha256 -days 365 -nodes -keyout AzureRootKey.pem -out AzureRootCert.cer -subj "/CN=AzureRootCert"

b. Generate the Client Certificate and Sign with Root Certificate:

- Generate a private key for the client certificate:

bash
openssl genpkey -algorithm RSA -out AzureClientKey.pem -pkeyopt rsa_keygen_bits:2048

- Generate a certificate signing request (CSR):

bash
openssl req -new -key AzureClientKey.pem -out AzureClientCert.csr -subj "/CN=AzureClientCert"

- Sign the client certificate with the root certificate:

bash
openssl x509 -req -in AzureClientCert.csr -CA AzureRootCert.cer -CAkey AzureRootKey.pem -CAcreateserial -out AzureClientCert.cer -days 365 -sha256

c. Export the Client Certificate with Private Key (PFX format):

bash
openssl pkcs12 -export -out AzureClientCert.pfx -inkey AzureClientKey.pem -in AzureClientCert.cer -certfile AzureRootCert.cer -password pass:yourpassword

# Resources created
- VNet with 2 subnets.  Default and GatewaySubnet
- KeyVault to store admin password of VM
- VM with private IP, NSG allowing port 80 and 3389 and enable IIS to display Default.html page
- Virtual network gateway
- Configured Point-to-Point Configuration.  Create root certificate.