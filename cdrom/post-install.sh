#!/bin/sh
set -xe

ANSIBLE_HOME=/var/lib/ansible
in-target usermod --home ${ANSIBLE_HOME} --move-home ansible

cp -r /cdrom/assets/. /target/
in-target chown -R ansible:ansible ${ANSIBLE_HOME}
in-target chmod 700 ${ANSIBLE_HOME}
in-target chmod 700 ${ANSIBLE_HOME}/.ssh
in-target chmod 600 ${ANSIBLE_HOME}/.ssh/authorized_keys
in-target chmod 440 /etc/sudoers.d/ansible

in-target systemctl enable dbus
in-target systemctl enable systemd-resolved systemd-networkd
in-target apt-get purge -y ifupdown
in-target update-grub
