#!/bin/bash

source utils.sh

# clean /var/cache/apt
sudo apt clean
sudo rm -rf /var/cache/apt
sudo mkdir -p /var/cache/apt

# prevent created unwanted subvolumes in debian
sudo touch /etc/tmpfiles.d/{portables,systemd-nspawn}.conf

#
find_and_replace "#greeter-hide-users=false" "greeter-hide-users=false" /etc/lightdm/lightdm.conf
find_and_replace "#greeter-show-manual-login=false" "greeter-show-manual-login=false" /etc/lightdm/lightdm.conf

# set cache to ram
add_text_to_file "
tmpfs /var/cache/apt tmpfs defaults,noatime,size=2G 0 0" /etc/fstab
sudo sh -c 'echo "" >> /etc/fstab'

mkdir -p $HOME/.cache/google-chrome

# sudo mount -a

# set vm.swappiness=10
sudo touch /etc/sysctl.d/99-swappiness.conf
add_text_to_file "
vm.swappiness=10" /etc/sysctl.d/99-swappiness.conf