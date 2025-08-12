#!/usr/bin/env bash
set -euo pipefail

# === Configuration ===
KEY_DIR=$HOME/secureboot_key                      
EFI_DIR=/boot/efi                                 
BOOTLOADER_ID=arch

echo "Installing required packages..."
sudo pacman -S --needed --noconfirm efibootmgr sbsigntools mkinitcpio
# if ! command -v yay &>/dev/null; then
#     echo "Error: 'yay' is not installed. Please install yay first."
#     exit 1
# fi
# yay -S --needed shim-signed

# sudo bash grub-sbsign $EFI_DIR $BOOTLOADER_ID $KEY_DIR

sudo cp 99-grub-mkconfig.hook /usr/share/libalpm/hooks
sudo cp 95-grub-install.hook /usr/share/libalpm/hooks
sudo cp grub-sbsign /usr/local/bin

sudo sed -i "s|\$1|$EFI_DIR|g" /usr/local/bin/grub-sbsign
sudo sed -i "s|\$2|$BOOTLOADER_ID|g" /usr/local/bin/grub-sbsign
sudo sed -i "s|\$3|$KEY_DIR|g" /usr/local/bin/grub-sbsign
sudo chmod +x /usr/local/bin/grub-sbsign

sudo pacman -S --noconfirm grub

echo "Copy efi files..."
sudo cp /usr/share/shim-signed/shimx64.efi $EFI_DIR/EFI/$BOOTLOADER_ID/BOOTx64.EFI
sudo cp /usr/share/shim-signed/mmx64.efi $EFI_DIR/EFI/$BOOTLOADER_ID/

EFI_DEV=$(findmnt -no SOURCE $EFI_DIR)
# Check if the device exists
if lsblk "$EFI_DEV" &>/dev/null; then
    # Get the parent disk name
    disk=$(lsblk -no pkname "$EFI_DEV")
    # Extract the partition number from the device name
    part=$(echo "$EFI_DEV" | grep -o '[0-9]\+$')
    echo "Disk: /dev/$disk"
    echo "Partition: $part"
    sudo efibootmgr --unicode --disk /dev/$disk --part $part --create --label "Arch-shim" --loader /EFI/$BOOTLOADER_ID/BOOTX64.EFI
else
    echo "Device $EFI_DEV does not exist"
    exit 1
fi


sudo mkdir -p /etc/initcpio/post/
sudo cp kernel-sbsign /etc/initcpio/post/
sudo sed -i "s|/path/to|$KEY_DIR|g" /etc/initcpio/post/kernel-sbsign
sudo chmod +x /etc/initcpio/post/kernel-sbsign

sudo mkinitcpio -P