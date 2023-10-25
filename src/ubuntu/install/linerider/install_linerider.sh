#!/bin/bash

#Bot automatically updates this when I make a new release.
version=2023.9.1

#Install Depends
sudo apt-get update
sudo apt-get install -y apt-transport-https dirmngr gnupg ffmpeg mono-devel unzip zip

rm -rf /tmp/LineRider
mkdir -p /tmp/LineRider/
cd /tmp/LineRider/

#Download LRA-Community-Edition build from repo
wget -O linerider.zip https://github.com/Sussy-OS/LRA-Community-Edition/releases/download/${version}/LineRider.game.auto-release.${version}-LR.zip

#Install
unzip linerider.zip
rm linerider.zip
cd /tmp/
sudo mv -f /tmp/LineRider/ /opt/LineRider/
sudo chmod +x /opt/LineRider/linerider.exe

#Create symbolic link to expected location at runtime
#because the source code relies on this hardcoded location in the users HOME folder, we can't reliably create it for all users at install time
#Create linerider command
sudo mkdir -p /usr/local/bin
echo '#!/bin/bash
mkdir -p ~/Documents/LRA/ffmpeg/linux/
ln -sf $(command -v ffmpeg) ~/Documents/LRA/ffmpeg/linux/ffmpeg
mono /opt/LineRider/linerider.exe' | sudo tee /usr/local/bin/linerider >/dev/null
sudo chmod +x /usr/local/bin/linerider

#Menu shortcut
sudo mkdir -p /usr/local/share/applications
echo "[Desktop Entry]
Name=LineRider
Comment=An Open Source spiritual successor to the flash game Line Rider
Icon=$HOME/icon-64.png
Exec=linerider
Path=/opt/LineRider/
Type=Application
Terminal=false
Categories=Game;" | sudo tee /usr/local/share/applications/LineRider.desktop >/dev/null

cp /usr/local/share/applications/LineRider.desktop $HOME/Desktop/
chmod +x $HOME/Desktop/LineRider.desktop
chown 1000:1000 $HOME/Desktop/LineRider.desktop