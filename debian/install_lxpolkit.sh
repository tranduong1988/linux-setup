#!/bin/bash

sudo apt install lxpolkit

mkdir -p ~/.config/autostart

cat > ~/.config/autostart/lxpolkit.desktop <<EOF
[Desktop Entry]
Name=PolicyKit Authentication Agent
Exec=lxpolkit
Type=Application
X-GNOME-Autostart-enabled=true
NoDisplay=true
EOF
