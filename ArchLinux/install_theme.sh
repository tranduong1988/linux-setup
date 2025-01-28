
sudo pacman -S --noconfirm ttf-roboto
sudo pacman -S --noconfirm ttf-0xproto-nerd 

yay -S --noconfirm candy-icons-git
yay -S --noconfirm nordic-theme-git 

xfconf-query -c xsettings -p /Net/ThemeName -s "Nordic"
xfconf-query -c xsettings -p /Net/IconThemeName -s "candy-icons"
xfconf-query -c xfwm4 -p /general/theme -s "Nordic"

xfconf-query -c xsettings -p /Gtk/FontName -s "Roboto Regular 10"
xfconf-query -c xfwm4 -p /general/title_font -s "Roboto Bold 9"
xfconf-query -c xfce4-terminal -p /font-name -s "0xProto Nerd Font Regular 12"
