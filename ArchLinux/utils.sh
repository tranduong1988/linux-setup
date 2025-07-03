#!/bin/bash
commandyay="yay"
if ! command -v yay &>/dev/null; then
    echo "Command 'yay' not found. Assigning yay=paru."
    yay() {
        paru "$@"
    }
    commandyay="paru"
fi

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
        echo "Error: File $target_file does not exist."
        return 1
    fi

    # Create a backup if not already created
    local backup_file="${target_file}.bak"
    if [[ ! -f "$backup_file" ]]; then
        sudo cp "$target_file" "$backup_file"
        echo "Backup created at $backup_file"
    fi
  
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

clone_plugin() {
    local OLD_ID="$1"
    local NEW_ID="$2"
    local PANEL_ID="${3:-0}"
    local CHANNEL="xfce4-panel"

    echo "📦 Checking old plugin (plugin-${OLD_ID})..."
    local OLD_PLUGIN_TYPE
    OLD_PLUGIN_TYPE=$(xfconf-query -c "$CHANNEL" -p "/plugins/plugin-${OLD_ID}" 2>/dev/null)

    if [ -z "$OLD_PLUGIN_TYPE" ]; then
        echo "❌ Plugin $OLD_ID does not exist."
        return 1
    fi

    echo "✅ Plugin ${OLD_ID} type: $OLD_PLUGIN_TYPE"

    echo "➕ Creating new plugin (plugin-${NEW_ID})..."
    xfconf-query -c "$CHANNEL" -p "/plugins/plugin-${NEW_ID}" -s "$OLD_PLUGIN_TYPE" --create -t string

    echo "🔁 Reading plugin-ids from panel-${PANEL_ID}..."
    local PLUGIN_IDS
    PLUGIN_IDS=$(xfconf-query -c "$CHANNEL" -p "/panels/panel-${PANEL_ID}/plugin-ids")

    if [[ -z "$PLUGIN_IDS" ]]; then
        echo "❌ Cannot find /panels/panel-${PANEL_ID}/plugin-ids."
        return 1
    fi

    local NEW_PLUGIN_IDS
    NEW_PLUGIN_IDS=$(echo "$PLUGIN_IDS" | sed "s/\b${OLD_ID}\b/${NEW_ID}/")

    echo "⚙️ Updating plugin-ids list..."
    xfconf-query -c "$CHANNEL" -p "/panels/panel-${PANEL_ID}/plugin-ids" -r
    for ID in $NEW_PLUGIN_IDS; do
        xfconf-query -c "$CHANNEL" -p "/panels/panel-${PANEL_ID}/plugin-ids" -n -t int -s "$ID"
    done

    read -rp "❓ Do you want to remove plugin-${OLD_ID}? (y/N): " DELETE
    if [[ "$DELETE" =~ ^[Yy]$ ]]; then
        xfconf-query -c "$CHANNEL" -p "/plugins/plugin-${OLD_ID}" -r
        echo "🗑 plugin-${OLD_ID} has been removed."
    fi

    echo "🔁 Restarting xfce4-panel..."
    xfce4-panel --restart

    echo "✅ Done: plugin-${OLD_ID} ➜ plugin-${NEW_ID}"
}
