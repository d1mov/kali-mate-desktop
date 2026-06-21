#!/bin/bash

echo "[+] Updating OS please wait..."
apt update > /dev/null 2>&1
apt upgrade -y > /dev/null 2>&1
apt full-upgrade -y > /dev/null 2>&1

echo "[+] Setting GRUB boot menu timeout to 0s..."
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub && sudo update-grub > /dev/null 2>&1

echo "[+] Installing Sublime Editor..."
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null 2>&1
echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources > /dev/null 2>&1
apt-get update > /dev/null 2>&1
apt-get install sublime-text > /dev/null 2>&1

echo "[+] Installing Mate Desktop..."
apt install -y kali-desktop-mate  > /dev/null 2>&1
update-alternatives --set x-session-manager /usr/bin/mate-session > /dev/null 2>&1

echo "[+] Installing Arc Theme..."
apt install arc-theme > /dev/null 2>&1
echo "[+] Installing Papirus Icon Theme..."
apt-get update > /dev/null 2>&1
apt-get install papirus-icon-theme > /dev/null 2>&1

sudo tee /root/.config/autostart/caja.desktop > /dev/null << 'EOF'
[Desktop Entry]
Type=Application
Exec=/usr/bin/caja --force-desktop
Hidden=false
X-MATE-Autostart-enabled=true
Name[en_GB]=caja
Name=caja
Comment[en_GB]=
Comment=
X-MATE-Autostart-Delay=0
EOF

sudo tee /root/.config/autostart/mate-panel.desktop > /dev/null << 'EOF'
[Desktop Entry]
Type=Application
Exec=mate-panel --replace
Hidden=false
Name=mate-panel
Comment=
X-MATE-Autostart-Delay=0
EOF

echo "[+] Downloading wallpaper..."
mkdir -p /usr/local/share/backgrounds/kali
wget -O /usr/local/share/backgrounds/kali/kali-oleo.png https://www.kali.org/wallpapers/images/2025/kali-oleo.png > /dev/null 2>&1

echo "[+] Installing Plank..."
sudo curl -fsSL https://zquestz.github.io/ppa/debian/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/zquestz-archive-keyring.gpg > /dev/null 2>&1
echo "deb [signed-by=/usr/share/keyrings/zquestz-archive-keyring.gpg] https://zquestz.github.io/ppa/debian ./" | sudo tee /etc/apt/sources.list.d/zquestz.list > /dev/null 2>&1
sudo apt update > /dev/null 2>&1
sudo apt install plank-reloaded -y > /dev/null 2>&1

sudo tee /root/.config/autostart/plank.desktop > /dev/null << 'EOF'
[Desktop Entry]
Type=Application
Exec=plank
Hidden=false
NoDisplay=false
X-MATE-Autostart-enabled=true
Name=Plank
X-MATE-Autostart-Delay=0
EOF

cat > /root/.config/autostart/apply-theme.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Apply Theme
Exec=bash -c 'gsettings set org.mate.background picture-filename /usr/local/share/backgrounds/kali/kali-oleo.png && gsettings set org.mate.Marco.general center-new-windows true && gsettings set org.mate.interface gtk-theme Arc-Dark && gsettings set org.mate.interface icon-theme Papirus-Dark && gsettings set org.mate.Marco.general theme Arc-Dark && gsettings set org.mate.peripherals-mouse cursor-theme mate-black && rm -f /root/.config/autostart/apply-theme.desktop'
X-MATE-Autostart-enabled=true
EOF

sudo tee /root/Desktop/plank_config.ini > /dev/null << 'EOF'
[dock1]
dock-items=['firefox-esr.dockitem', 'mate-terminal.dockitem', 'kali-burpsuite.dockitem', 'kali-metasploit-framework.dockitem', 'org.wireshark.Wireshark.dockitem']
hide-mode='intelligent'
icon-size=50
position='right'
zoom-enabled=true

[dock1/net/launchpad/plank/docks/dock1]
position='right'
EOF

echo "[+] Configuring mate-terminal..."
sudo tee /root/Desktop/mate-terminal.txt > /dev/null << 'EOF'
[profiles/default]
allow-bold=false
background-color='#21212C2B4242'
background-darkness=0.94999999999999996
background-type='transparent'
bold-color='#000000000000'
default-size-columns=110
default-size-rows=24
foreground-color='#D4D4D8D8DFDF'
palette='#21212C2B4242:#21212C2B4242:#A3A3EAEA2A2A:#ECECBBBB0A0A:#A3A3EAEA2A2A:#ECECBBBB0A0A:#7979BEBEFFFF:#E6E6E6E6E6E6:#21212C2B4242:#A3A3EAEA2A2A:#A3A3EAEA2A2A:#ECECBBBB0A0A:#7979BEBEFFFF:#ECECBBBB0A0A:#7979BEBEFFFF:#FFFFFFFFFFFF'
use-custom-default-size=true
use-theme-colors=false
visible-name='Default'
EOF

dconf load /org/mate/terminal/ < /root/Desktop/mate-terminal.txt

echo "[+] Configuring mate-panel..."
sudo tee /root/Desktop/mate-panel.txt > /dev/null << 'EOF'
[general]
object-id-list=['menu-bar', 'notification-area', 'clock', 'object-0', 'object-1', 'object-2', 'object-3', 'object-4', 'object-5', 'object-6']
toplevel-id-list=['top']

[objects/clock]
applet-iid='ClockAppletFactory::ClockApplet'
locked=true
object-type='applet'
position=0
relative-to-edge='end'
toplevel-id='top'

[objects/clock/prefs]
cities=@as []
custom-format=''
format='24-hour'

[objects/menu-bar]
locked=true
object-type='menu-bar'
position=0
toplevel-id='top'

[objects/notification-area]
applet-iid='NotificationAreaAppletFactory::NotificationArea'
locked=true
object-type='applet'
position=10
relative-to-edge='end'
toplevel-id='top'

[objects/object-0]
applet-iid='MultiLoadAppletFactory::MultiLoadApplet'
object-type='applet'
position=243
relative-to-edge='end'
toplevel-id='top'

[objects/object-0/prefs]
cpuload-color0='rgb(115,210,22)'
cpuload-color1='rgb(115,210,22)'
cpuload-color2='rgb(0,163,255)'
size=uint32 70
speed=uint32 100

[objects/object-1]
applet-iid='WnckletFactory::WorkspaceSwitcherApplet'
object-type='applet'
position=211
relative-to-edge='end'
toplevel-id='top'

[objects/object-2]
launcher-location='/usr/share/applications/firefox-esr.desktop'
object-type='launcher'
position=246
toplevel-id='top'

[objects/object-3]
launcher-location='/usr/share/applications/mate-terminal.desktop'
object-type='launcher'
position=309
toplevel-id='top'

[objects/object-4]
launcher-location='/usr/share/applications/sublime_text.desktop'
object-type='launcher'
position=277
toplevel-id='top'

[objects/object-5]
applet-iid='CommandAppletFactory::CommandApplet'
object-type='applet'
position=1376
toplevel-id='top'

[objects/object-5/prefs]
command='echo "Kali IP:"'
interval=140

[objects/object-6]
applet-iid='CommandAppletFactory::CommandApplet'
object-type='applet'
position=1432
toplevel-id='top'

[objects/object-6/prefs]
command="bash -c \"hostname -I | awk '{print $1}'\""
interval=140

[toplevels/top]
expand=true
orientation='top'
screen=0
size=24
EOF

dconf load /org/mate/panel/ < /root/Desktop/mate-panel.txt

echo "[+] Adding Plank dock items..."
# Add launchers to plank*
mkdir -p "/root/.config/plank/dock1/launchers"

# Clean existing dock items
rm -f "/root/.config/plank/dock1/launchers/*.dockitem"

# 1. Firefox
cat > "/root/.config/plank/dock1/launchers/firefox-esr.dockitem" << 'EOF'
#This file auto-generated by Plank.
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/firefox-esr.desktop
SortBy=name
DirectoryStyle=0
ShowHiddenFiles=false
LargeIcons=false
EOF

# 2. MATE Terminal
cat > "/root/.config/plank/dock1/launchers/mate-terminal.dockitem" << EOF
#This file auto-generated by Plank.
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/mate-terminal.desktop
SortBy=name
DirectoryStyle=0
ShowHiddenFiles=false
LargeIcons=false
EOF

# 3. Burp Suite
cat > "/root/.config/plank/dock1/launchers/kali-burpsuite.dockitem" << EOF
#This file auto-generated by Plank.
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/kali-burpsuite.desktop
SortBy=name
DirectoryStyle=0
ShowHiddenFiles=false
LargeIcons=false
EOF

# 4. Metasploit
cat > "/root/.config/plank/dock1/launchers/kali-metasploit-framework.dockitem" << EOF
#This file auto-generated by Plank.
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/kali-metasploit-framework.desktop
SortBy=name
DirectoryStyle=0
ShowHiddenFiles=false
LargeIcons=false
EOF

# 5. Wireshark
cat > "/root/.config/plank/dock1/launchers/org.wireshark.Wireshark.dockitem" << EOF
#This file auto-generated by Plank.
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/org.wireshark.Wireshark.desktop
SortBy=name
DirectoryStyle=0
ShowHiddenFiles=false
LargeIcons=false
EOF

dconf load /net/launchpad/plank/docks/ < /root/Desktop/plank_config.ini

echo "[+] Plank dock items created successfully!"

echo "[+] Cleaning up..."
rm -f /root/Desktop/plank_config.ini
rm -f /root/Desktop/mate-terminal.txt
rm -f /root/Desktop/mate-panel.txt

echo "[+] VM Provisioned successfully!"

echo "[+] Rebooting in:"
for i in 5 4 3 2 1; do
    echo "$i..."
    sleep 1
done

echo "[+] Rebooting now!"
reboot
