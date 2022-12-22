#!/bin/bash

# ubuntu server 22.04 minimal

# disable snap
echo '
Package: snapd
Pin: release a=*
Pin-Priority: -10
' | sudo tee /etc/apt/preferences.d/snapd.pref

# firefox
sudo add-apt-repository ppa:mozillateam/ppa
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/firefox.pref

# utilities
LIST+=(vim git)
LIST+=(iptables pppoeconf iputils-ping)

# ui
LIST+=(xinit awesome rxvt-unicode firefox)

sudo apt install -y ${LIST[@]}

# awesome wm
mkdir -p ~/.config/awesome
cp /etc/xdg/awesome/rc.lua ~/.config/awesome/
