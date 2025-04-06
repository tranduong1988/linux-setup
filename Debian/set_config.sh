#!/bin/bash

source utils.sh

#
find_and_replace "#greeter-hide-users=false" "greeter-hide-users=false" /etc/lightdm/lightdm.conf
find_and_replace "#greeter-show-manual-login=false" "greeter-show-manual-login=false" /etc/lightdm/lightdm.conf

# set cache to ram
add_text_to_file "
tmpfs $HOME/.cache/google-chrome tmpfs defaults,noatime,size=512M 0 0
#tmpfs $HOME/.cache/microsoft-edge tmpfs defaults,noatime,size=512M 0 0
tmpfs /var/cache/apt tmpfs defaults,noatime,size=2G 0 0" /etc/fstab
sudo sh -c 'echo "" >> /etc/fstab'

mkdir -p $HOME/.cache/google-chrome

# sudo mount -a

# set vm.swappiness=10
# sudo touch /etc/sysctl.conf
add_text_to_file "
vm.swappiness=10" /etc/sysctl.conf