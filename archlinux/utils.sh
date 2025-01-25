#!/bin/bash

get_aur_helper() {
    AUR_HELPER=$(command -v yay || command -v paru)
    if [ -z "$AUR_HELPER" ]; then
        echo "No AUR helper found. Installing yay..."
        sudo pacman -S --needed --noconfirm base-devel git
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay
        current=$(pwd)
        cd /tmp/yay
        makepkg -si --noconfirm
        cd $current
        rm -rf /tmp/yay
        AUR_HELPER=$(command -v yay)
        echo 'AUR_HELPER is $AUR_HELPER'
    fi
    
    echo $AUR_HELPER
}

add_text_to_file() {
    local text_to_add="$1"   # Text to add
    local target_file="$2"   # File to modify

    # Check if both arguments are provided
    if [[ -z "$text_to_add" || -z "$target_file" ]]; then
        echo "Usage: add_text_to_file \"text_to_add\" target_file"
        return 1
    fi

    # Check if the target file exists
    if [[ ! -f "$target_file" ]]; then
        # echo "Error: File $target_file does not exist."
        # return 1
        sudo touch "$target_file"
    fi

    # Create a backup if not already created
    # local backup_file="${target_file}.bak"
    # if [[ ! -f "$backup_file" ]]; then
    #     sudo cp "$target_file" "$backup_file"
    #     echo "Backup created at $backup_file"
    # fi
  
    # Check if the text already exists
    if ! awk -v RS="\0" -v search="$text_to_add" '{if (index($0, search) > 0) found=1} END {exit !found}' "$target_file"; then
        echo "$text_to_add" | sudo tee -a "$target_file" > /dev/null
        echo "Text added to $target_file"
    else
        echo "Text already exists in $target_file. No changes made."
    fi
}


# Hàm để tìm và thay thế văn bản trong file
find_and_replace() {
    local find_text="$1"       # Chuỗi cần tìm
    local replace_text="$2"    # Chuỗi thay thế
    local file="$3"            # File cần thay đổi

    # Kiểm tra xem file có tồn tại hay không
    if [[ ! -f "$file" ]]; then
        echo "File $file does not exist."
        return 1
    fi

    # Sử dụng sed để thay thế
    sudo sed -i "s|$find_text|$replace_text|g" "$file"
    echo "Replaced \"$find_text\" by \"$replace_text\" in file $file."
}

add_swapfile() {
    local swapsize="$1"

    # set swapfile
    sudo swapoff -a

    sudo rm /swapfile

    sudo fallocate -l "$swapsize" /swapfile

    # sudo dd if=/dev/zero of=/swapfile bs=1M count=4096

    sudo chmod 600 /swapfile

    sudo mkswap /swapfile

    sudo swapon /swapfile

    add_text_to_file "
/swapfile none swap sw 0 0" /etc/fstab

    sudo swapon --show
}

rename_launchers_safely() {
    local START="$1"
    local CONFIG_DIR="$HOME/.config/xfce4/panel"

    if [ -z "$START" ]; then
        echo "❌ Usage: rename_launchers_safely <start-number>"
        return 1
    fi

    # Get a sorted list of current launcher directories
    mapfile -t launchers < <(find "$CONFIG_DIR" -maxdepth 1 -type d -name "launcher-*" | sort)

    echo "🔁 Temporarily renaming launcher directories..."
    for dir in "${launchers[@]}"; do
        base="$(basename "$dir")"
        mv "$dir" "$CONFIG_DIR/${base}.bak"
    done

    echo "🎯 Renaming to launcher-$START, launcher-$(($START + 1)), ..."
    local i="$START"
    for dir in "${launchers[@]}"; do
        base="$(basename "$dir")"
        mv "$CONFIG_DIR/${base}.bak" "$CONFIG_DIR/launcher-$i"
        ((i++))
    done

    echo "✅ Launcher renaming completed successfully."
}
