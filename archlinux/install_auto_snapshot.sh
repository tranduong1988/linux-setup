#!/bin/bash

source utils.sh

AUR_HELPER=$(get_aur_helper)
if [ -z "$AUR_HELPER" ]; then
    echo 'Can not find AUR_HELPER...'
    exit 0
fi

sudo pacman -S --noconfirm timeshift
sudo pacman -S --noconfirm grub-btrfs 
sudo pacman -S --noconfirm inotify-tools

$AUR_HELPER -S --noconfirm --needed timeshift-autosnap

# copy my timeshift-auto snap file
sudo cp ./timeshift-autosnap/timeshift-autosnap /usr/bin/
sudo cp ./timeshift-autosnap/timeshift-autosnap.conf /etc/

# edit file grub-btrfsd
sudo systemctl enable grub-btrfsd
sudo systemctl start grub-btrfsd
grub_btrfsd_file=$(sudo systemctl cat grub-btrfsd | head -n 1 | sed 's/^# //')
find_and_replace "--syslog /.snapshots" "--syslog --timeshift-auto" $grub_btrfsd_file
sudo systemctl restart grub-btrfsd