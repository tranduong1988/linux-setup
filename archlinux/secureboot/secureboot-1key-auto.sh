#!/usr/bin/env bash
set -euo pipefail

# === Configuration ===
KEY_DIR=~/secureboot-key                       # Directory to store Secure Boot keys
EFI_DIR=/boot/EFI/BOOT                         # EFI System Partition target directory
GRUB_EFI=/boot/grub/x86_64-efi/core.efi        # Path to GRUB EFI binary
KERNEL=/boot/vmlinuz-linux                     # Path to Linux kernel
INITRAMFS=/boot/initramfs-linux.img            # Path to initramfs

echo "[1/6] Installing required packages..."
# grub, efibootmgr, sbsigntools, efitools are in official repos
sudo pacman -S --needed --noconfirm grub efibootmgr sbsigntools efitools
# shim-signed is in AUR
if ! command -v yay &>/dev/null; then
    echo "Error: 'yay' is not installed. Please install yay first."
    exit 1
fi
yay -S --needed shim-signed

echo "[2/6] Creating key directory..."
mkdir -p "$KEY_DIR"
cd "$KEY_DIR"

echo "[3/6] Generating Secure Boot key and certificate..."
# Create a single key pair (private key + self-signed certificate)
# Valid for 10 years (3650 days)
openssl req -new -x509 -newkey rsa:2048 \
  -keyout SB.key -out SB.crt \
  -days 3650 \
  -subj "/CN=My SecureBoot Key/" \
  -nodes -sha256

echo "[4/6] Signing GRUB and Linux kernel..."
mkdir -p signed
# Sign GRUB EFI binary
sbsign --key SB.key --cert SB.crt --output signed/grubx64.efi "$GRUB_EFI"
# Sign Linux kernel
sbsign --key SB.key --cert SB.crt --output signed/vmlinuz-linux "$KERNEL"
# Copy initramfs (not signed, but must match signed kernel)
cp "$INITRAMFS" signed/

echo "[5/6] Installing shim and signed GRUB into EFI partition..."
sudo mkdir -p "$EFI_DIR"
# Install shim signed by Microsoft (acts as first-stage loader)
sudo cp /usr/share/shim-signed/shimx64.efi "$EFI_DIR/BOOTX64.EFI"
# Install signed GRUB binary
sudo cp signed/grubx64.efi "$EFI_DIR/"

echo "[6/6] Enrolling key into UEFI 'db'..."
# Create EFI Signature List (ESL) from certificate
GUID=$(uuidgen)
cert-to-efi-sig-list -g "$GUID" SB.crt SB.esl
# Create authenticated update file (.auth) to add key into db
sign-efi-sig-list -c SB.crt -k SB.key db SB.esl SB.auth
# Update UEFI variable 'db' to include our key (Secure Boot must be OFF now)
sudo efi-updatevar -f SB.auth db

echo "========================================="
echo "✔ Secure Boot key generated and enrolled."
echo "Next steps:"
echo "  1. Reboot into BIOS/UEFI setup."
echo "  2. Enable Secure Boot."
echo "  3. Boot back into Arch Linux."
