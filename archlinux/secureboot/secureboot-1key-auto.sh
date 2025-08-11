#!/usr/bin/env bash
set -euo pipefail

# === Configuration ===
KEY_DIR=~/secureboot-key                       # Where to store Secure Boot key & cert
EFI_DIR=/boot/EFI/BOOT                         # EFI partition target directory
KERNEL=/boot/vmlinuz-linux                     # Path to Linux kernel

echo "[1/5] Installing required packages..."
sudo pacman -S --needed --noconfirm grub efibootmgr sbsigntools mokutil
if ! command -v yay &>/dev/null; then
    echo "Error: 'yay' is not installed. Please install yay first."
    exit 1
fi
yay -S --needed shim-signed

echo "[2/5] Copy efi files..."
mv $EFI_DIR/BOOTx64.EFI $EFI_DIR/grubx64.efi
sudo cp /usr/share/shim-signed/shimx64.efi $EFI_DIR/BOOTx64.EFI
sudo cp /usr/share/shim-signed/mmx64.efi $EFI_DIR


echo "[3/5] Generating Secure Boot key..."
mkdir -p "$KEY_DIR"
cd "$KEY_DIR"
openssl req -newkey rsa:2048 -nodes -keyout MOK.key -new -x509 -sha256 -days 3650 -subj "/CN=my Machine Owner Key/" -out MOK.crt
openssl x509 -outform DER -in MOK.crt -out MOK.cer

echo "[4/5] Signing GRUB and Linux kernel..."
sbsign --key MOK.key --cert MOK.crt --output /boot/vmlinuz-linux /boot/vmlinuz-linux
sbsign --key MOK.key --cert MOK.crt --output $EFI_DIR/grubx64.efi $EFI_DIR/grubx64.efi

echo "Enrolling key into MOK list..."
# mokutil will prompt for a temporary password
sudo mokutil --import SB.crt

