# XMind-Linux-Installer

BASH script to install XMind 8 on Debian.

Includes Launcher, MIME type link and icon.

# Install

1.  Dependencies

        sudo apt install unzip default-jre libgtk2.0-0 libwebkitgtk-1.0-0 lame libc6 libglib2.0-0

2.  Download XMind: http://www.xmind.net/download/linux/

3.  Get the scripts `git clone https://github.com/fmorato/XMind-Linux-Installer.git`

        cd XMind-Linux-Installer
        mv ~/Downloads/xmind8-update?-linux.zip .
        sudo chmod +x xmind-installer.sh
        sudo ./xmind-installer.sh username

    username is the linux user that will run the software.

4.  Add execute permission to the installer script and run it,
    `chmod +x xmind-installer.sh`; `sudo ./xmind-installer.sh username`

# Uninstall

    sudo chmod +x uninstaller.sh
    sudo ./uninstaller.sh username

# Credits

Some commands were borrowed from https://github.com/dinos80152/XMind-Linux-Installer

# Motivation

This script is an automation of [this process](http://www.xmind.net/m/PuDC)

![process](https://xmindshare.s3.amazonaws.com/preview/PuDC-FwEzHqO-77495.png)

Icon : http://www.iconarchive.com/show/papirus-apps-icons-by-papirus-team/xmind-icon.html
