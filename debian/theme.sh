#!/bin/bash

source utils.sh

ICON_URL=$(curl -s https://api.github.com/repos/PapirusDevelopmentTeam/papirus-icon-theme/releases/latest \
    | grep tarball_url \
    | cut -d '"' -f 4)

if [ ! -z "$ICON_URL" ]; then
    ICON_TEMP=$(mktemp -d)
    mkdir -p $ICON_TEMP
    curl -L $ICON_URL | tar -xzf - -C $ICON_TEMP --strip-components=1
    current=$(pwd)
    cd $ICON_TEMP
    ./install.sh
    cd $current
fi

THEME_URL=$(curl -s https://api.github.com/repos/vinceliuice/Matcha-gtk-theme/releases/latest \
    | grep tarball_url \
    | cut -d '"' -f 4)

if [ ! -z "$THEME_URL" ]; then
    THEME_TEMP=$(mktemp -d)
    mkdir -p $THEME_TEMP
    curl -L $THEME_URL | tar -xzf - -C $THEME_TEMP --strip-components=1
    current=$(pwd)
    cd $THEME_TEMP
    ./install.sh
    cd $current
fi

FONT_DIR=$HOME/.local/share/fonts

FONT_NAME="JetBrainsMono Nerd Font Mono"
if fc-list :family | grep -iq "$FONT_NAME"; then
    printf "Font '%s' is installed.\n" "$FONT_NAME"
else
    FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
        | grep "browser_download_url.*JetBrainsMono.tar.xz" \
        | cut -d '"' -f 4)
    if [ ! -z "$FONT_URL" ]; then
        mkdir -p $FONT_DIR/$FONT_NAME
        curl -L $FONT_URL | tar -xJf - -C $FONT_DIR/$FONT_NAME "JetBrainsMonoNerdFontMono-Regular.ttf"
        printf "'%s' installed successfully.\n" "$FONT_NAME"
    else
        printf "Font '%s' not installed. No .tar.xz file found in latest release"
    fi
fi

FONT_NAME="Inter Display"
if fc-list :family | grep -iq "$FONT_NAME"; then
    printf "Font '%s' is installed.\n" "$FONT_NAME"
else
    FONT_URL=$(curl -s https://api.github.com/repos/rsms/inter/releases/latest \
        | grep "browser_download_url.*\\.zip" \
        | cut -d '"' -f 4)
    if [ ! -z "$FONT_URL" ]; then
        TEMP_DIR=$(mktemp -d)
        curl -L $FONT_URL -o "$TEMP_DIR"/"$FONT_NAME".zip
        mkdir -p $FONT_DIR/$FONT_NAME
        unzip -j "$TEMP_DIR"/"$FONT_NAME".zip "extras/ttf/InterDisplay-Regular.ttf" -d $FONT_DIR/$FONT_NAME
        rm -rf "${TEMP_DIR}"
        printf "'%s' installed successfully.\n" "$FONT_NAME"
    else
        printf "Font '%s' not installed. No .zip file found in latest release"
    fi
fi
fc-cache -fv

xfconf-query -c xsettings -p /Net/ThemeName -s "Matcha-dark-sea" --create -t string
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark" --create -t string
xfconf-query -c xfwm4 -p /general/theme -s "Matcha-dark-sea" --create -t string

xfconf-query -c xsettings -p /Gtk/FontName -s "Inter Display Regular 10" --create -t string
xfconf-query -c xfwm4 -p /general/title_font -s "Inter Display Bold 9" --create -t string
xfconf-query -c xfce4-terminal -p /font-name -s "0xProto Nerd Font Mono Regular 11" --create -t string
xfconf-query -c xfce4-terminal -p /misc-menubar-default -s false --create -t bool
xfconf-query -c xfce4-terminal -p /background-mode -s "TERMINAL_BACKGROUND_TRANSPARENT" --create -t string
xfconf-query -c xfce4-terminal -p /background-darkness -s 0.75 --create -t double
xfconf-query -c xfce4-terminal -p /misc-default-geometry -s "120x30" --create -t string

# Copy home directory contents
echo "Copying home directory contents..."
if [ -d "./home/username/" ]; then
    cp -rf ./home/username/. $HOME/
    echo "Home directory copied successfully."
else
    echo "./home/username/ not found. Skipping home directory copy."
fi

# cp xfce4-panel.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
rename_launchers_safely 16
CONFIG_DIR="$HOME/.config/xfce4/panel"

mapfile -t file < <(find "$CONFIG_DIR/launcher-16" -maxdepth 1 -type f -name "*" | sort)
dir=$(dirname "$file")
mv "$file" "$dir/terminal.desktop"

mapfile -t file < <(find "$CONFIG_DIR/launcher-17" -maxdepth 1 -type f -name "*" | sort)
dir=$(dirname "$file")
mv "$file" "$dir/filemanager.desktop"

mapfile -t file < <(find "$CONFIG_DIR/launcher-18" -maxdepth 1 -type f -name "*" | sort)
dir=$(dirname "$file")
mv "$file" "$dir/browser.desktop"

mapfile -t file < <(find "$CONFIG_DIR/launcher-19" -maxdepth 1 -type f -name "*" | sort)
dir=$(dirname "$file")
mv "$file" "$dir/appfind.desktop"
