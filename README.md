# README.md

## Manual installation

*Reference*: https://ostechnix.com/ubuntu-install-kvm/

### Install all necessary packets

```sh
$ sudo apt install -y --needed \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils \
  virtinst
```

### Start *libvirtd* service

```sh
$ sudo systemctl enable libvirtd
$ sudo systemctl start libvirtd
```

### Add permissions

```sh
$ sudo usermod -aG kvm $USER
$ sudo usermod -aG libvirt $USER
```

### Set up a bridge network

*Reference*: https://fabianlee.org/2022/09/20/kvm-creating-a-bridged-network-with-netplan-on-ubuntu-22-04/

>Note: Working with **Networking** depends on the specific use case of it. For a server I recommend setting up the main ethernet interface as the *master* of a *bridge* interface (may called br0). As we're on an ubuntu machine, we'll use **netplan**

```sh
$ sudo vim /etc/netplan/{tab_for_autocomplete}.yml
```
paste the following:

```yml
network:
  version: 2
  renderer: networkd

  ethernets:
    <your_main_interface>:
      dhcp4: false 
      dhcp6: false 

  bridges:
    br0:
      interfaces: [<your_main_interface>]
      addresses: [192.168.0.100/24]
      # gateway4 is deprecated, use routes instead
      routes:
      - to: default
        via: 192.168.0.1
        metric: 100
        on-link: true
      mtu: 1500
      nameservers:
        addresses: [192.168.0.1]
      parameters:
        stp: true
        forward-delay: 4
      dhcp4: no
      dhcp6: no
```

and run: 

```sh
$ sudo chmod 600 /etc/netplan/{tab_for_autocomplete}.yml
$ sudo netplan apply
```

>Note: You may encounter a WARNING message like *WARNING:root:Cannot call Open vSwitch: ovsdb-server.service is not running*. You may ignore it or just do ```$ sudo apt install -y openvswitch-switch```
