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
rm "$HOME"/.local/share/applications/xmind.desktop \
"$HOME"/.local/share/mime/packages/xmind.xml \
"$HOME"/.local/share/fonts/xmind/** \
"$HOME"/.local/share/icons/hicolor/scalable/**/*xmind.svg

rmdir "$HOME"/.local/share/fonts/xmind/
if [ $? != 0 ]
then
  status_flag=1
  echoR "Failed"
else
  echoY "OK"
fi
echoY "...Updating MIME, applications, font and icon database"
update-desktop-database "$HOME"/.local/share/applications
update-mime-database "$HOME"/.local/share/mime
gtk-update-icon-cache --quiet "$HOME"/.local/share/icons/hicolor/ -f
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
