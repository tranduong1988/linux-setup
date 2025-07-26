#!/bin/bash

source utils.sh

# clean /var/cache/pacman/pkg
yes | sudo pacman -Scc

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
echo 'Edit config pacman.conf...'
find_and_replace "#ParallelDownloads" "ParallelDownloads" /etc/pacman.conf
find_and_replace "#CacheDir    = /var/cache/pacman/pkg/" "CacheDir    = /tmp/pacman_pkg" /etc/pacman.conf


# set cache for google-chrome
echo 'set google-chrome cache to ram'
current=$(pwd)
cd ../ram-cache
bash install.sh
cd $current

# set cache to ram
echo 'set aur_helper and pacman cache to ram'
AUR_HELPER=$(get_aur_helper)
AUR_TOOL_NAME=$(basename $AUR_HELPER)

if [ -n "$AUR_TOOL_NAME" ]; then
    systemctl --user enable cache2ram@$AUR_TOOL_NAME.service
    systemctl --user restart cache2ram@$AUR_TOOL_NAME.service
fi

# set vm.swappiness=10
echo 'Set vm.swappiness=10'
add_text_to_file "
vm.swappiness=10" /etc/sysctl.d/99-swappiness.conf

