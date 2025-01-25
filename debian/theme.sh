#!/bin/bash

source utils.sh

ICON_PATH=/tmp/icon
mkdir -p $ICON_PATH
curl -L https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/refs/tags/20250501.tar.gz | tar -xzf - -C $ICON_PATH --strip-components=1
current=$(pwd)
cd $ICON_PATH
./install.sh
cd $current

THEME_PATH=/tmp/theme
mkdir -p $THEME_PATH
curl -L https://github.com/vinceliuice/Matcha-gtk-theme/archive/refs/tags/2025-04-11.tar.gz | tar -xzf - -C $THEME_PATH --strip-components=1
current=$(pwd)
cd $THEME_PATH
./install.sh
cd $current


FONTS_PATH=$HOME/.local/share/fonts
mkdir -p $FONTS_PATH
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.tar.xz | tar -xJf - -C $FONTS_PATH "JetBrainsMonoNerdFontMono-Regular.ttf"
curl -L https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip -o /tmp/Inter-4.1.zip
unzip -j /tmp/Inter-4.1.zip "extras/ttf/InterDisplay-Regular.ttf" -d $FONTS_PATH
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
