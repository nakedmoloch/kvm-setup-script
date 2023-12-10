# qemu-kvm-dependencies
Installs all necessary packets for libvirt/qemu/kvm

---

### Arch-based distros:
```sh
pacman -Sy --needed \
  qemu \
  dhclient \
  openbsd-netcat \
  virt-viewer \
  libvirt \
  dnsmasq \
  ebtables \
  virt-install \
  virt-manager \
  bridge-utils
```

---

### Debian-based distros:

```sh
apt install -y --needed \
  qemu \
  dhclient \
  openbsd-netcat \
  virt-viewer \
  libvirt \
  dnsmasq \
  ebtables \
  virt-install \
  virt-manager \
  bridge-utils
```

---

### Redhat-based distros:

```sh
dnf install -y --needed \
  qemu \
  dhclient \
  openbsd-netcat \
  virt-viewer \
  libvirt \
  dnsmasq \
  ebtables \
  virt-install \
  virt-manager \
  bridge-utils
```
