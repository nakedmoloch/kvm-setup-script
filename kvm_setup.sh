#!/bin/bash

sudo apt update

sudo apt install -y --needed \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils \
  virtinst

sudo systemctl enable libvirtd
sudo systemctl start libvirtd

sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER

echo "KVM ready!"
