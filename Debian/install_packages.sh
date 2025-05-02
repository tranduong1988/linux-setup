#!/bin/bash

sudo apt install -y fonts-noto fonts-noto-cjk fonts-noto-color-emoji fonts-noto-extra
sudo apt install -y git
sudo apt install -y curl
sudo apt install -y 7zip
sudo apt install -y unrar
sudo apt install -y unzip
sudo apt install -y sysstat
sudo apt install -y htop
sudo apt install -y btop
sudo apt install -y tlp
sudo apt install -y vlc
sudo apt install -y qbittorrent
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo apt install -y rsync
sudo apt install -y build-essential
sudo apt install -y fcitx5-bamboo
sudo apt install -y systemd-zram-generator 
sudo apt install -y --no-install-recommends texstudio
sudo apt install -y rofi



# third party package

curl -fsSL -o /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb

curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update
sudo apt install code

# pyenv, nvm, goenv, starship
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

echo "Installing goenv..."
git clone https://github.com/go-nv/goenv.git ~/.goenv

echo "Installing pyenv..."
curl https://pyenv.run | bash

# Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
echo "Install Docker...."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin




echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh

