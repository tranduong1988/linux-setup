#!/bin/bash

source utils.sh

# clean /var/cache/apt
sudo apt clean
sudo rm -rf /var/cache/apt
sudo mkdir -p /var/cache/apt

# prevent created unwanted subvolumes in debian
sudo touch /etc/tmpfiles.d/{portables,systemd-nspawn}.conf

#
echo 'Set greeter-hide-users and greeter-show-manual-login'
find_and_replace "#greeter-hide-users=false" "greeter-hide-users=false" /etc/lightdm/lightdm.conf
find_and_replace "#greeter-show-manual-login=false" "greeter-show-manual-login=false" /etc/lightdm/lightdm.conf

# set cache for google-chrome
echo 'set google-chrome cache to ram'
current=$(pwd)
cd ../ram-cache
bash install.sh
cd $current

# set cache to ram
add_text_to_file "Dir::Cache    /tmp/apt_cache;" /etc/apt/apt.conf
add_text_to_file "d /tmp/apt_cache/archives/partial 0755 root root -" /etc/tmpfiles.d/apt_cache.conf
sudo systemd-tmpfiles --create

# set vm.swappiness=10
echo 'Set vm.swappiness=10'
add_text_to_file "
vm.swappiness=10" /etc/sysctl.d/99-swappiness.conf