#!/usr/bin/env bash
set -euo pipefail

key_dir=$HOME/secureboot-key 

echo "Installing mokutil..."
sudo pacman -S --needed --noconfirm mokutil

echo "Generating Secure Boot key..."
mkdir -p "$key_dir"
cd "$key_dir"
openssl req -newkey rsa:2048 -nodes -keyout MOK.key -new -x509 -sha256 -days 3650 -subj "/CN=My ArchLinux Key/" -out MOK.crt
openssl x509 -outform DER -in MOK.crt -out MOK.cer

echo "Enrolling key into MOK list..."
# mokutil will prompt for a temporary password
sudo mokutil --import MOK.cer