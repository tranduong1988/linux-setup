#!/bin/bash

source utils.sh

# clean /var/cache/pacman/pkg
sudo pacman -Scc

# prevent created unwanted subvolumes in cachyOS
sudo btrfs sub delete /var/lib/machines
sudo btrfs sub delete /var/lib/portables
sudo touch /etc/tmpfiles.d/{portables,systemd-nspawn}.conf

# add_swapfile 2G
find_and_replace "#ParallelDownloads" "ParallelDownloads" /etc/pacman.conf

# set cache to ram
add_text_to_file "
/home/var/cache     /var/cache      none    bind    0   0
/home/var/log       /var/log        none    bind    0   0
/home/var/tmp       /var/tmp        none    bind    0   0
tmpfs $HOME/.cache/$commandyay tmpfs defaults,noatime,size=2G 0 0
tmpfs /var/cache/pacman/pkg tmpfs defaults,noatime,size=2G 0 0" /etc/fstab
sudo sh -c 'echo "" >> /etc/fstab'

mkdir -p $HOME/.cache/$commandyay

sudo rm -rf /var/cache
sudo rm -rf /var/log
sudo rm -rf /var/tmp

sudo mkdir -p /var/cache
sudo mkdir -p /var/log
sudo mkdir -p /var/tmp

sudo mkdir -p /home/var/cache
sudo mkdir -p /home/var/log
sudo mkdir -p /home/var/tmp

sudo mount -a

# set pacman and yay
# cp -r .bash_alias ~/
# add_text_to_file "
# source ~/.bash_alias" ~/.bashrc

cp -r .config ~/
mkdir -p $HOME/Desktop
mkdir -p $HOME/Downloads
mkdir -p $HOME/Documents
mkdir -p $HOME/Music
mkdir -p $HOME/Pictures
mkdir -p $HOME/Templates
mkdir -p $HOME/Videos

sudo cp pacman-db-unlock.service /etc/systemd/system/
sudo systemctl enable pacman-db-unlock

# set vm.swappiness=10
sudo touch /etc/sysctl.d/99-swappiness.conf
add_text_to_file "
vm.swappiness=10" /etc/sysctl.d/99-swappiness.conf

