#!/bin/bash
if [ -z "$1" ]
then
	echo "USAGE:
	sudo xmind-installer.sh username"
	exit 1
fi
USER=$1
status_flag=0
echo "Uninstalling XMind"
echo "Removing files..."
rm -rf /opt/xmind/
if [ $? != 0 ]
then
  status_flag=1
  echo "Failed"
else
  echo "OK"
fi
echo "Removing user data..."
rm -rf /home/$USER/xmind-workspace
if [ $? != 0 ]
then
  status_flag=1
  echo "Failed"
else
  echo "OK"
fi
echo "Removing configs..."
rm -rf /home/$USER/.config/xmind/
if [ $? != 0 ]
then
  status_flag=1
  echo "Failed"
else
  echo "OK"
fi
echo "Removing launcher, mime, fonts, icon..."
rm /usr/share/applications/xmind.desktop \
/usr/share/mime/packages/xmind.xml \
/usr/share/fonts/truetype/xmind/** \
/usr/share/icons/hicolor/scalable/**/*xmind.svg

rmdir /usr/share/fonts/truetype/xmind/
if [ $? != 0 ]
then
  status_flag=1
  echo "Failed"
else
  echo "OK"
fi
echo "...Updating MIME, applications, font and icon database"
update-desktop-database /usr/share/applications
update-mime-database /usr/share/mime
gtk-update-icon-cache --quiet /usr/share/icons/hicolor/ -f
fc-cache -f
if [ $? != 0 ]
then
  status_flag=1
  echo "Failed"
else
  echo "OK"
fi
if [ $status_flag != 0 ]
then
  echo "Some errors found..."
  exit 1
else
  echo "Uninstallation finished succesfully"
  exit 0
fi
