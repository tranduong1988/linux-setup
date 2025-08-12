#!/usr/bin/env bash
set -euo pipefail

# === Configuration ===
KEY_DIR=$HOME/secureboot-key                       # Where to store Secure Boot key & cert
EFI_DIR=/boot/efi                              # EFI partition target directory
BOOTLOADER_ID=arch
echo "Installing required packages..."
sudo pacman -S --needed --noconfirm grub efibootmgr sbsigntools
if ! command -v yay &>/dev/null; then
    echo "Error: 'yay' is not installed. Please install yay first."
    exit 1
fi
yay -S --needed shim-signed

echo "Copy efi files..."
sudo cp /usr/share/shim-signed/shimx64.efi $EFI_DIR/EFI/$BOOTLOADER_ID/BOOTx64.EFI
sudo cp /usr/share/shim-signed/mmx64.efi $EFI_DIR/EFI/$BOOTLOADER_ID/

EFI_DEV=$(findmnt -no SOURCE $EFI_DIR)
# Check if the device exists
if lsblk "$EFI_DEV" &>/dev/null; then
    # Get the parent disk name
    disk=$(lsblk -no pkname "$dev")
    # Extract the partition number from the device name
    part=$(echo "$dev" | grep -o '[0-9]\+$')
    echo "Disk: /dev/$disk"
    echo "Partition: $part"
    sudo efibootmgr --unicode --disk /dev/$disk --part $part --create --label "Arch-shim" --loader /EFI/$BOOTLOADER_ID/BOOTX64.EFI
else
    echo "Device $EFI_DEV does not exist"
    exit 1
fi

echo "Grub-install..."
GRUB_MODULES="ext2 fat part_gpt part_msdos linux search search_fs_uuid search_fs_file search_label normal efinet all_video boot btrfs cat chain configfile echo efifwsetup efinet ext2 fat font gettext gfxmenu gfxterm gfxterm_background gzio halt help hfsplus iso9660 jpeg keystatus loadenv loopback linux ls lsefi lsefimmap lsefisystab lssal memdisk minicmd normal ntfs part_apple part_msdos part_gpt password_pbkdf2 png probe reboot regexp search search_fs_uuid search_fs_file search_label serial sleep smbios squash4 test tpm true video xfs zfs zfscrypt zfsinfo cpuid play cryptodisk gcry_arcfour gcry_blowfish gcry_camellia gcry_cast5 gcry_crc gcry_des gcry_dsa gcry_idea gcry_md4 gcry_md5 gcry_rfc2268 gcry_rijndael gcry_rmd160 gcry_rsa gcry_seed gcry_serpent gcry_sha1 gcry_sha256 gcry_sha512 gcry_tiger gcry_twofish gcry_whirlpool luks lvm mdraid09 mdraid1x raid5rec raid6rec http tftp"
sudo grub-install --target=x86_64-efi --efi-directory=$EFI_DIR --bootloader-id=$BOOTLOADER_ID --modules="$GRUB_MODULES" --sbat /usr/share/grub/sbat.csv --no-nvram

echo "Signing GRUB and Linux kernel..."
GRUBX64_FILE="$EFI_DIR/EFI/$BOOTLOADER_ID/grubx64.efi"
sudo sbsign --key $KEY_DIR/MOK.key --cert $KEY_DIR/MOK.crt --output $GRUBX64_FILE $GRUBX64_FILE


sudo mkdir -p /etc/initcpio/post/
sudo cp kernel-sbsign /etc/initcpio/post/
sudo sed -i "s|/path/to|$KEY_DIR|g" /etc/initcpio/post/kernel-sbsign
sudo chmod +x /etc/initcpio/post/kernel-sbsign

sudo mkinitcpio -P