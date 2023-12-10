#!/bin/bash

# Ensure the script is running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

# Exit immediately if any command exits with a non-zero status
set -e

# Function to display a failure message
on_error() {
    echo "Error encountered. Exiting..."
}

# Set up the error handler
trap on_error EXIT

# Install required packages
apt update
apt install -y \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils \
  virtinst

# Start and enable libvirtd service
systemctl enable libvirtd
systemctl start libvirtd

# Add the user to kvm and libvirt groups
usermod -aG kvm $SUDO_USER
usermod -aG libvirt $SUDO_USER

# Display a list of network interfaces
echo "Available network interfaces:"
ip link show | grep -E '^[0-9]+: ' | cut -d' ' -f2 | cut -d':' -f1

# Prompt for network configuration details
read -p "Enter the Ethernet adapter name (e.g., enp3s0): " eth_adapter
read -p "Enter the IP address and subnet in CIDR format (e.g., 192.168.0.100/24): " ip_address
read -p "Enter the gateway address: " gateway_address
read -p "Enter the DNS address: " dns_address

# Generate netplan configuration file
cat <<EOF > /etc/netplan/00-installer-config.yaml
network:
  version: 2
  renderer: networkd

  ethernets:
    $eth_adapter:
      dhcp4: false
      dhcp6: false

  bridges:
    br0:
      interfaces: [$eth_adapter]
      addresses: [$ip_address]
      routes:
      - to: default
        via: $gateway_address
        metric: 100
        on-link: true
      mtu: 1500
      nameservers:
        addresses: [$dns_address]
      parameters:
        stp: true
        forward-delay: 4
      dhcp4: no
      dhcp6: no
EOF

# Apply the netplan configuration
chmod 600 /etc/netplan/00-installer-config.yaml
netplan apply

# Remove the error handler if the script reaches this point without errors
trap - EXIT

# Display the success message
echo "QEMU/KVM configured successfully."
