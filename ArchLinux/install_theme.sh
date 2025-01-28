
sudo pacman -S --noconfirm ttf-roboto
sudo pacman -S --noconfirm ttf-0xproto-nerd 

mkdir -p $HOME/.local/share/icons
git clone https://github.com/EliverLara/candy-icons.git $HOME/.local/share/icons

mkdir -p $HOME/.local/share/themes
git clone https://github.com/EliverLara/Nordic.git $HOME/.local/share/themes

xfconf-query -c xsettings -p /Net/ThemeName -s "Nordic"
xfconf-query -c xsettings -p /Net/IconThemeName -s "candy-icons"
xfconf-query -c xfwm4 -p /general/theme -s "Nordic"

xfconf-query -c xsettings -p /Gtk/FontName -s "Roboto Regular 10"
xfconf-query -c xfwm4 -p /general/title_font -s "Roboto Bold 9"
xfconf-query -c xfce4-terminal -p /font-name -s "0xProto Nerd Font Regular 12"
