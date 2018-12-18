#!/bin/usr/env bash
#
# This script reverses the installation process.
# Changes made to the install script should be updated here as well.
#

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
	echo "USAGE:
	sudo xmind-installer.sh username"
	exit 1
fi
# Check first for username and then load config
source ./xmind.conf

status_flag=0
echoY "Uninstalling XMind"
echoY "Removing files..."
rm -rf "${XMIND_DIR}"
if [ $? != 0 ]
then
  status_flag=1
  echoR "Failed"
else
  echoY "OK"
fi
echoY "Removing user data..."
rm -rf "${XMIND_WORKSPACE}"
if [ $? != 0 ]
then
  status_flag=1
  echoR "Failed"
else
  echoY "OK"
fi
echoY "Removing configs..."
rm -rf "${XMIND_CONFIG}"
if [ $? != 0 ]
then
  status_flag=1
  echoR "Failed"
else
  echoY "OK"
fi
echoY "Removing launcher, mime, fonts, icon..."
rm /usr/share/applications/xmind.desktop \
/usr/share/mime/packages/xmind.xml \
/usr/share/fonts/truetype/xmind/** \
/usr/share/icons/hicolor/scalable/**/*xmind.svg

rmdir /usr/share/fonts/truetype/xmind/
if [ $? != 0 ]
then
  status_flag=1
  echoR "Failed"
else
  echoY "OK"
fi
echoY "...Updating MIME, applications, font and icon database"
update-desktop-database /usr/share/applications
update-mime-database /usr/share/mime
gtk-update-icon-cache --quiet /usr/share/icons/hicolor/ -f
fc-cache -f
if [ $? != 0 ]
then
  status_flag=1
  echoR "Failed"
else
  echoY "OK"
fi
if [ $status_flag != 0 ]
then
  echoR "Some errors found..."
  exit 1
else
  echoY "Uninstallation finished succesfully"
  exit 0
fi
