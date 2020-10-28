# XMind-Linux-Installer

BASH script to install XMind 8 on Debian.

Includes Launcher, MIME type link and icon. Some GNOME themes come with XMind icon and they have precedence over the one that is included.

# Install

1.  Dependencies
    
    Requires Java 8.
    
    Fedora
    
        sudo dnf install unzip webkitgtk gtk2 glibc lame java-1.8.0
    
    Debian
    
        sudo apt install unzip default-jre libgtk2.0-0 libwebkitgtk-1.0-0 lame libc6 libglib2.0-0

2.  Get the scripts 

        git clone https://github.com/fmorato/XMind-Linux-Installer.git
        cd XMind-Linux-Installer

3.  See `xmind.conf` for configuration options and setting XMind version.

4.  Add execute permission to the installer script and run it:
	
        sudo chmod +x xmind-install.sh
        sudo ./xmind-install.sh

# Uninstall

    sudo chmod +x xmind-uninstall.sh
    sudo ./xmind-uninstall.sh

# Credits

Some commands were borrowed from https://github.com/dinos80152/XMind-Linux-Installer

# Motivation

This script is an automation of [this process](http://www.xmind.net/m/PuDC)

![process](https://xmindshare.s3.amazonaws.com/preview/PuDC-FwEzHqO-77495.png)

Icon : http://www.iconarchive.com/show/papirus-apps-icons-by-papirus-team/xmind-icon.html
