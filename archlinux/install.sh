#!/bin/bash

source utils.sh

# Install AUR helper if not found
AUR_HELPER=$(get_aur_helper)

if [ -z "$AUR_HELPER" ]; then
    echo 'Can not find AUR_HELPER...'
    exit 0
fi

echo "pre config..."
bash pre_config.sh

# install iptables-nft 
yes | $AUR_HELPER -S iptables-nft 

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
        $AUR_HELPER -S --mflags --skipinteg --noconfirm --needed "${packages[@]}"
    else
        echo "No valid packages found in pkgs.txt"
    fi
else
    echo "pkgs.txt not found. Skipping package installation."
fi

echo "post config..."
bash post_config.sh