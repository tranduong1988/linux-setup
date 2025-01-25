#!/bin/bash

source utils.sh

echo "pre config..."
bash pre_config.sh

# Read packages from pkgs.txt and install in one go
if [ -f "pkgs.txt" ]; then
    # Create an array of packages (skip comments and empty lines)
    packages=()
    while IFS= read -r pkg || [ -n "$pkg" ]; do
        pkg=$(echo "$pkg" | sed 's/#.*$//')  # Remove comments
        pkg=$(echo "$pkg" | xargs)           # Trim whitespace
        [ -n "$pkg" ] && packages+=("$pkg")  # Add to array if not empty
    done < "pkgs.txt"
    
    # Install all packages in one command if array is not empty
    if [ ${#packages[@]} -gt 0 ]; then
        echo "Installing packages: ${packages[*]}"
        sudo apt-get install -y --no-install-recommends "${packages[@]}"
    else
        echo "No valid packages found in pkgs.txt"
    fi
else
    echo "pkgs.txt not found. Skipping package installation."
fi

# third party package

curl -fsSL -o /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb

curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update
sudo apt install code

# Install NVM (Node Version Manager)
# This will install NVM and set it up for the current user
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

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

echo "post config..."
bash post_config.sh