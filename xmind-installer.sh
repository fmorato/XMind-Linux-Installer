#!/bin/bash
##
## XMind 8 Installer
##
## Author: Felipe Morato - me@fmorato.com
## Author: Mohammad Riza Nurtam - muhammadriza@gmail.com
##
## Licensed under GPL V3
## Please refer to https://www.gnu.org/licenses/gpl-3.0.en.html
##
## How to use this script
## 1. run the script using privileged user or using sudo command
## 2. don't forget to pass the user of the program in the command argument
##
## example
## sudo bash xmind8-installer.sh uname

ARCH=`uname -m`
XMIND_DIR="/opt/xmind"
if [ $ARCH == "x86_64" ]
then
	VERSION="XMind_amd64"
	BIN_DIR=$XMIND_DIR/$VERSION
elif [ $ARCH == "i686" ]
then
	VERSION="XMind_i386"
	BIN_DIR=$XMIND_DIR/$VERSION
else
	echo 'Sorry, cannot verify your OS architecture'
	echo 'The installer will now exit'
	exit 1
fi

if [ -z "$1" ]
then
	echo "USAGE:
	sudo xmind-installer.sh username"
  exit 1
fi

xtrct(){
	echo "Extracting files..."
	mkdir -p $XMIND_DIR
	unzip -q xmind-8-update?-linux.zip -d $XMIND_DIR
}

fnt(){
	echo "Installing additional fonts..."
	mkdir -p /usr/share/fonts/truetype/xmind
	cp -R $XMIND_DIR/fonts/* /usr/share/fonts/truetype/xmind
	fc-cache -f
}

lnchr(){
	echo "Creating laucher..."
	cat << EOF >> /usr/share/applications/xmind.desktop
	[Desktop Entry]
	Comment=Create and share mind maps.
	Exec=$BIN_DIR/XMind %F
	Name=XMind
	Encoding=UTF-8
	Terminal=false
	Type=Application
	StartupNotify=true
	Categories=Office;
	Icon=xmind
	MimeType=application/xmind;
EOF
update-desktop-database /usr/share/applications
}

cnfg(){
	echo "Creating workspace and configuration..."
	mkdir /home/$1/.config/xmind/
	mkdir /home/$1/xmind-workspace/
	cp -R $BIN_DIR/configuration/* /home/$1/.config/xmind/
	chown -R $1:$1 /home/$1/.config/xmind/
	chown -R $1:$1 /home/$1/xmind-workspace/
	sed -i "s/\.\/configuration/@user\.home\/\.config\/xmind/g" "$BIN_DIR/XMind.ini"
	sed -i "s/\.\.\/workspace/@user\.home\/xmind\-workspace/g" "$BIN_DIR/XMind.ini"
}

mimeicns(){
	echo "Updating MIME database and icons"
	cp xmind.xml /usr/share/mime/packages/
	update-mime-database /usr/share/mime
	cp -r xmind.svg /usr/share/icons/hicolor/scalable/apps/
	cp -r xmind.svg /usr/share/icons/hicolor/scalable/mimetypes/application-xmind.svg
	gtk-update-icon-cache --quiet /usr/share/icons/hicolor/ -f
}

xtrct
if [ $? = 0 ]
then
	fnt
	lnchr
	cnfg $1
	mimeicns
	echo "Installation finished. Happy mind mapping!"
else
	echo "Instalation failed"
	exit 1
fi
