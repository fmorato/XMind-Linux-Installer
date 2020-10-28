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
## This script downloads and installs xmind for the current user.
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
## 1. run the script using unprivileged user
##
## example
## sudo bash xmind-install.sh

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

source ./xmind.conf

ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]
then
	VERSION="XMind_amd64"
elif [ "$ARCH" == "i686" ]
then
	VERSION="XMind_i386"
else
	echo 'Sorry, cannot verify your OS architecture'
	echo 'The installer will now exit'
	exit 1
fi
BIN_DIR=$XMIND_DIR/$VERSION

dl() {
	echoY "Downloading XMIND 8 to ${XMIND_FILENAME}"

	if ! wget --user-agent="${USER_AGENT}" -O "${XMIND_FILENAME}" "${XMIND_LINK}${XMIND_FILENAME}"; then
		echoR "ERROR: couldn't download XMIND" >&2
		exit 1
	fi
}

xtrct(){
	echoY "Extracting files..."
	mkdir -p "${XMIND_DIR}"
	if ! unzip -q "${XMIND_FILENAME}" -d "${XMIND_DIR}"; then
		echoR "ERROR: couldn't extract XMIND" >&2
		exit 1
	fi

	echoY "Removing downloaded file..."
	rm "${XMIND_FILENAME}"
}

fnt(){
	echoY "Installing additional fonts..."
	mkdir -p "$HOME"/.local/share/fonts/xmind
	cp -R "$XMIND_DIR"/fonts/* "$HOME"/.local/share/fonts/xmind
	fc-cache -f
}

lnchr(){
	echoY "Creating laucher..."
cat << EOF > "$HOME"/.local/share/applications/xmind.desktop
[Desktop Entry]
Comment=Create and share mind maps.
Exec=JAVA_HOME=/usr/lib/jvm/java-1.8.0/jre/ $BIN_DIR/XMind %F
Name=XMind 8
Encoding=UTF-8
Terminal=false
Type=Application
StartupNotify=true
Categories=Office;
Icon=xmind
MimeType=application/xmind;
EOF
update-desktop-database "$HOME"/.local/share/applications
}

cnfg(){
	echoY "Creating workspace and configuration..."
	mkdir -p "${XMIND_CONFIG}"
	mkdir -p "${XMIND_WORKSPACE}"
	sed -i "s/\.\/configuration/@user\.home\/\.config\/xmind/g" "$BIN_DIR/XMind.ini"
	sed -i "s/\.\.\/workspace/@user\.home\/xmind\-workspace/g" "$BIN_DIR/XMind.ini"
	sed -i "s/\.xmind/\.config\/xmind/g" "$BIN_DIR/XMind.ini"
	sed -i "s/\.\./\@user\.home\/XMind8/g" "$BIN_DIR/XMind.ini"
	sed -i "s/\/\.xmind/\/\.config\/xmind/g" "$BIN_DIR/configuration/config.ini"
	cp -R "$BIN_DIR"/configuration/* "${XMIND_CONFIG}"
}

mimeicns(){
	echoY "Updating MIME database and icons"
	mkdir -p "$HOME"/.local/share/mime/packages/
	cp xmind.xml "$HOME"/.local/share/mime/packages/
	update-mime-database "$HOME"/.local/share/mime
	mkdir -p "$HOME"/.local/share/icons/hicolor/mimetypes/
	mkdir -p "$HOME"/.local/share/icons/hicolor/scalable/apps/
	cp xmind.svg "$HOME"/.local/share/icons/hicolor/mimetypes/
	cp xmind.svg "$HOME"/.local/share/icons/hicolor/scalable/apps/application-xmind.svg
	gtk-update-icon-cache --quiet "$HOME/.local/share/icons/hicolor/" -f
}

dl
xtrct
fnt
lnchr
cnfg
mimeicns

echoY "Installation finished. Happy mind mapping!"
