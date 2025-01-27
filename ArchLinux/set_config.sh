#!/bin/bash

source utils.sh

# add_swapfile 2G


# set cache to ram
add_text_to_file "
tmpfs '$HOME'/.cache/google-chrome tmpfs defaults,noatime,size=512M 0 0
#tmpfs '$HOME'/.cache/microsoft-edge tmpfs defaults,noatime,size=512M 0 0
tmpfs '$HOME'/.cache/yay tmpfs defaults,noatime,size=2G 0 0
tmpfs /var/cache/pacman/pkg tmpfs defaults,noatime,size=2G 0 0" /etc/fstab
sudo sh -c 'echo "" >> /etc/fstab'

mkdir -p $HOME/.cache/yay
mkdir -p $HOME/.cache/google-chrome

sudo mount -a

# set pacman and yay
cp -r .bash_alias ~/
add_text_to_file "
source ~/.bash_alias" ~/.bashrc

cp -r .config ~/
mkdir -p $HOME/Desktop
mkdir -p $HOME/Downloads
mkdir -p $HOME/Documents
mkdir -p $HOME/Music
mkdir -p $HOME/Pictures
mkdir -p $HOME/Templates
mkdir -p $HOME/Videos

# set vm.swappiness=10
sudo touch /etc/sysctl.d/99-swappiness.conf
add_text_to_file "
vm.swappiness=10" /etc/sysctl.d/99-swappiness.conf

