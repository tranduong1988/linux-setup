#!/usr/bin/env bash
set -euo pipefail
conf="/etc/secureboot.conf"
if [ -f $conf ]; then 
	source $conf
else
	sudo cp secureboot.conf /etc/
fi


echo "Installing required packages..."
sudo pacman -S --needed --noconfirm efibootmgr sbsigntools mkinitcpio
# if ! command -v yay &>/dev/null; then
#     echo "Error: 'yay' is not installed. Please install yay first."
#     exit 1
# fi
# yay -S --needed shim-signed

# sudo bash grub-sbsign $EFI_DIR $BOOTLOADER_ID $KEY_DIR

sudo cp {99-grub-mkconfig.hook,95-grub-install.hook} /usr/share/libalpm/hooks
sudo cp grub-sbsign /usr/local/bin

sudo pacman -S --noconfirm grub

echo "Copy efi files..."
sudo cp /usr/share/shim-signed/{shim,mm}x64.efi $esp/EFI/$bootloader_id/

efi_dev=$(findmnt -no SOURCE $esp)
# Check if the device exists
if lsblk "$efi_dev" &>/dev/null; then
    LABEL="$bootloader_id (Secure Boot)"
    if efibootmgr | grep -Fq "$LABEL"; then
        echo "Boot entry '$LABEL' already exists"
    else
        disk=$(lsblk -no pkname "$efi_dev")
        # Extract the partition number from the device name
        part=$(echo "$efi_dev" | grep -o '[0-9]\+$')
        echo "Disk: /dev/$disk"
        echo "Partition: $part"
        sudo efibootmgr --unicode --disk /dev/$disk --part $part --create --label $LABEL --loader /EFI/$bootloader_id/shimx64.efi
    fi
else
    echo "Device $efi_dev does not exist"
    exit 1
fi


sudo mkdir -p /etc/initcpio/post/
sudo cp kernel-sbsign /etc/initcpio/post/
sudo chmod +x /etc/initcpio/post/kernel-sbsign

sudo mkinitcpio -P