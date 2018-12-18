#!/bin/usr/env bash
##
## XMind 8 Installer
##
## Author: Felipe Morato - me@fmorato.com
## Author: Mohammad Riza Nurtam - muhammadriza@gmail.com
##
## Licensed under GPL V3
## Please refer to https://www.gnu.org/licenses/gpl-3.0.en.html
##
## This script downloads and installs xmind in the system.
## .xmind files open automatically from the file manager in
## XMind and a logo is provided. Some GNOME themes already come
## with XMind icons and they have precedence over the one that is
## included.
##
## Find configuration options on xmind.conf
##
## To remove XMind from the system, see xmind-uninstall.sh.
##
## How to use this script
## 1. run the script using privileged user or using sudo command
##
## example
## sudo bash xmind-install.sh uname

function echoY() {
    prompt="$1"
    echo -e -n "\033[32m$prompt"
    echo -e -n '\033[0m'
    echo ''
}
function echoR() {
    prompt="$1"
    echo -e -n "\033[31m$prompt"
    echo -e -n '\033[0m'
    echo ''
}

if [ -z "$1" ]
then
	echoY "USAGE:
	sudo xmind-installer.sh username"
  exit 1
fi
# Check first for username and then load config
source ./xmind.conf

ARCH=`uname -m`
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

dl() {
	echoY "Downloading XMIND to /tmp/${XMIND_FILENAME}"
	if ! wget --user-agent="${USER_AGENT}" -O "/tmp/${XMIND_FILENAME}" "${XMIND_LINK}${XMIND_FILENAME}"; then
		echoR "ERROR: couldn't download XMIND" >&2
		exit 1
	fi
}

xtrct(){
	echoY "Extracting files..."
	mkdir -p "${XMIND_DIR}"
	if ! unzip -q "/tmp/${XMIND_FILENAME}" -d "${XMIND_DIR}"; then
		echoR "ERROR: couldn't extract XMIND" >&2
		exit 1
	fi

	echoY "Removing downloaded file..."
	rm "/tmp/${XMIND_FILENAME}"
}

fnt(){
	echoY "Installing additional fonts..."
	mkdir -p /usr/share/fonts/truetype/xmind
	cp -R $XMIND_DIR/fonts/* /usr/share/fonts/truetype/xmind
	fc-cache -f
}

lnchr(){
	echoY "Creating laucher..."
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
	echoY "Creating workspace and configuration..."
	mkdir -p "${XMIND_CONFIG}"
	mkdir -p "${XMIND_WORKSPACE}"
	cp -R $BIN_DIR/configuration/* "${XMIND_CONFIG}"
	chown -R ${1}:${1} "${XMIND_CONFIG}"
	chown -R ${1}:${1} "${XMIND_WORKSPACE}"
	sed -i "s/\.\/configuration/@user\.home\/\.config\/xmind/g" "$BIN_DIR/XMind.ini"
	sed -i "s/\.\.\/workspace/@user\.home\/xmind\-workspace/g" "$BIN_DIR/XMind.ini"
}

mimeicns(){
	echoY "Updating MIME database and icons"
	cp xmind.xml /usr/share/mime/packages/
	update-mime-database /usr/share/mime
	cp -r xmind.svg /usr/share/icons/hicolor/scalable/apps/
	cp -r xmind.svg /usr/share/icons/hicolor/scalable/mimetypes/application-xmind.svg
	gtk-update-icon-cache --quiet /usr/share/icons/hicolor/ -f
}

dl
xtrct
fnt
lnchr
cnfg $1
mimeicns

echoY "Installation finished. Happy mind mapping!"
