#!/bin/bash

source utils.sh

# add_swapfile 2G


# set cache to ram
add_text_to_file "
tmpfs /home/'$USER'/.cache/google-chrome tmpfs defaults,noatime,size=512M 0 0
#tmpfs /home/'$USER'/.cache/microsoft-edge tmpfs defaults,noatime,size=512M 0 0
tmpfs /home/'$USER'/.cache/yay tmpfs defaults,noatime,size=2G 0 0
tmpfs /var/cache/pacman/pkg tmpfs defaults,noatime,size=2G 0 0" /etc/fstab
sudo sh -c 'echo "" >> /etc/fstab'

# set pacman and yay
cp -r .bash_alias ~/
add_text_to_file "
source ~/.bash_alias" ~/.bashrc

cp -r .config ~/


# set vm.swappiness=10
add_text_to_file "
vm.swappiness=10" /etc/sysctl.d/99-swappiness.conf

