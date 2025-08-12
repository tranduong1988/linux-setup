#!/usr/bin/env bash
set -euo pipefail

KEY_DIR=$HOME/secureboot-key 

echo "Generating Secure Boot key..."
mkdir -p "$KEY_DIR"
cd "$KEY_DIR"
openssl req -newkey rsa:2048 -nodes -keyout MOK.key -new -x509 -sha256 -days 3650 -subj "/CN=My ArchLinux Key/" -out MOK.crt
openssl x509 -outform DER -in MOK.crt -out MOK.cer