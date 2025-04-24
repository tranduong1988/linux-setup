#!/bin/bash

source utils.sh

sudo pacman -S --noconfirm timeshift
sudo pacman -S --noconfirm grub-btrfs 
sudo pacman -S --noconfirm inotify-tools

if ! command -v yay &>/dev/null; then
    echo "Command 'yay' not found. Assigning yay=paru."
    yay() {
        paru "$@"
    }
fi
yay -S --noconfirm --needed timeshift-autosnap

# edit file timeshift-autosnap config
timeshift_autosnap_file='/etc/timeshift-autosnap.conf'
find_and_replace "updateGrub=true" "updateGrub=false" $timeshift_autosnap_file
find_and_replace "maxSnapshots=3" "maxSnapshots=5" $timeshift_autosnap_file

# copy file grub.hook
sudo cp grub.hook /usr/share/libalpm/hooks/grub.hook

# edit file grub-btrfsd
sudo systemctl enable grub-btrfsd
sudo systemctl start grub-btrfsd
grub_btrfsd_file=$(sudo systemctl cat grub-btrfsd | head -n 1 | sed 's/^# //')
find_and_replace "--syslog /.snapshots" "--syslog --timeshift-auto" $grub_btrfsd_file
sudo systemctl restart grub-btrfsd