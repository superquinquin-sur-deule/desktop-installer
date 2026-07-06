# store installer

Unattended install of Superquinquin’s Linux desktop.

## Build ISO files

First of all, download a official Debian iso file.
Adapt `Makefile`.
Build the custom ISO file with variables as following.

```console
$ make ISOLABEL=INSTALLER-202607 ISOBASEFILE=debian-13.5.0-amd64-netinst.iso
```

Cache any .deb on your project.

```console
$ make cdrom/packages/*.deb
```

## Prepare USB stick

Plug your USB stick and identify its block device

```console
$ make DEVICE=/dev/sdc usb
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdc      8:32   1  3.7G  0 disk
├─sdc1   8:33   1  753M  0 part
└─sdc2   8:34   1  3.5M  0 part

Are you sure you want to wipe /dev/sdc? [y/N] y
188+1 records in
188+1 records out
789884928 bytes (790 MB, 753 MiB) copied, 74.0032 s, 10.7 MB/s
```

## Expected state after install

- Post-install steps are registered in `/var/log/installer/syslog` with `post-install` tag
- Splash screen with plymouth theme (see [custom theme](https://github.com/superquinquin-sur-deule/debian-theme))
- DHCP configuration with `systemd-networkd`
- Passwordless access for `ansible` sudo user, with keys register in [authorized_keys](cdrom/assets/var/lib/ansible/.ssh/authorized_keys)
- Python3 librairies for Ansible playbooks

## Testing

Legacy Boot on a volatile 20GB-sized qcow file.

```console
$ make test-boot               # start the VM
$ make OUTPUT=2 test-boot      # emulate a dual-screen (default: 1)
$ make --always-make test-boot # fresh install
```

UEFI boot requires OVMF library (depend on your workstation).

```console
$ make OVMF=/usr/share/edk2/x64/OVMF.4m.fd test-boot
```

Connect to the VM.

```console
$ ssh -F ssh_config desktop
```

## References

- Modifying an installation ISO image to preseed the installer from its initrd <https://wiki.debian.org/DebianInstaller/Preseed/EditIso>
- Automatiser l’installation de Debian avec un fichier preseed.cfg <https://blog.lof.ovh/fr/posts/tutoriels/automatisation-installation-debian-avec-preseed/>
- Syslinux Comboot/menu.c32 <https://wiki.syslinux.org/wiki/index.php?title=Comboot/menu.c32>
- Grub Theme file format (Common properties) <https://www.gnu.org/software/grub/manual/grub/html_node/Theme-file-format.html#Common-properties>
