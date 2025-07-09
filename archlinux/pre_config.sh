#!/bin/bash

source utils.sh

# clean /var/cache/pacman/pkg
sudo pacman -Scc

# prevent created unwanted subvolumes in cachyOS
sudo btrfs sub delete /var/lib/machines
sudo btrfs sub delete /var/lib/portables
sudo touch /etc/tmpfiles.d/{portables,systemd-nspawn}.conf

# Copy root directory contents
echo "Copying root directory contents..."
if [ -d "./root" ]; then
    sudo cp -rn ./root/. /
    echo "Root directory copied successfully."
else
    echo "./root not found. Skipping root directory copy."
fi

# unrem ParallelDownloads
echo 'unrem ParallelDownloads...'
find_and_replace "#ParallelDownloads" "ParallelDownloads" /etc/pacman.conf

# set cache to ram
echo 'set aur_helper and pacman cache to ram'
AUR_HELPER=$(get_aur_helper)
AUR_TOOL_NAME=$(basename $AUR_HELPER)
if [ -n "$AUR_TOOL_NAME" ]; then
add_text_to_file "
tmpfs $HOME/.cache/$AUR_TOOL_NAME tmpfs defaults,noatime,size=2G 0 0" /etc/fstab
fi

add_text_to_file "
tmpfs /var/cache/pacman/pkg tmpfs defaults,noatime,size=2G 0 0
" /etc/fstab

mkdir -p $HOME/.cache/$AUR_TOOL_NAME

sudo mount -a
sudo systemctl daemon-reload

echo "create home folder..."
cp -r .config ~/
mkdir -p $HOME/Desktop
mkdir -p $HOME/Downloads
mkdir -p $HOME/Documents
mkdir -p $HOME/Music
mkdir -p $HOME/Pictures
mkdir -p $HOME/Templates
mkdir -p $HOME/Videos

# set vm.swappiness=10
echo 'Set vm.swappiness=10'
sudo touch /etc/sysctl.d/99-swappiness.conf
add_text_to_file "
vm.swappiness=10" /etc/sysctl.d/99-swappiness.conf

