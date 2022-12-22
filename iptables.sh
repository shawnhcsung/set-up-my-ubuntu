#!/bin/sh

LAN=enp2s0

# clean up
sudo iptables -F
sudo iptables -X
sudo iptables -Z

# default policies
sudo iptables -P INPUT   DROP
sudo iptables -P OUTPUT  DROP
sudo iptables -P FORWARD DROP


#================================
# INPUT
#================================
sudo iptables -A INPUT -j ACCEPT -m conntrack --ctstate RELATED,ESTABLISHED

sudo iptables -A INPUT -j ACCEPT -i lo

sudo iptables -A INPUT -j ACCEPT -i $LAN -p icmp -m conntrack --ctstate NEW
sudo iptables -A INPUT -j ACCEPT -i $LAN -p tcp --dport 22      # ssh
sudo iptables -A INPUT -j ACCEPT -i $LAN -p tcp --dport 80      # web admin
sudo iptables -A INPUT -j ACCEPT -i $LAN -p udp --dport 67:68   # dhcp
sudo iptables -A INPUT -j ACCEPT -i $LAN -p udp --dport 53      # dns
sudo iptables -A INPUT -j ACCEPT -i $LAN -p tcp --dport 53      # dns
sudo iptables -A INPUT -j ACCEPT -i $LAN -p udp --dport 137:139 # samba
sudo iptables -A INPUT -j ACCEPT -i $LAN -p tcp --dport 445     # samba

#sudo iptables -A INPUT -j LOG --log-prefix "[iptables] INPUT:DROP " --log-level 5 --log-ip-options --log-uid


#================================
# OUTPUT
#================================
sudo iptables -A OUTPUT -j ACCEPT -m conntrack --ctstate RELATED,ESTABLISHED
sudo iptables -A OUTPUT -j DROP   -m conntrack --ctstate INVALID

sudo iptables -A OUTPUT -j ACCEPT -p tcp --dport 22 -m conntrack --ctstate NEW # ssh (github)
sudo iptables -A OUTPUT -j ACCEPT -p udp --dport 53 -m conntrack --ctstate NEW # dns query
sudo iptables -A OUTPUT -j ACCEPT -p tcp --dport 53 -m conntrack --ctstate NEW # dns query

sudo iptables -A OUTPUT -j ACCEPT -o lo

sudo iptables -A OUTPUT -j ACCEPT -o $LAN -p udp --dport 67:68   # dhcp
sudo iptables -A OUTPUT -j ACCEPT -o $LAN -p udp --dport 137:139 # samba


sudo iptables -A OUTPUT -j LOG --log-prefix "[iptables] OUTPUT:DROP " --log-level 5 --log-ip-options --log-uid


#================================
# FORWARD
#================================
sudo iptables -A FORWARD -j ACCEPT -m conntrack --ctstate RELATED,ESTABLISHED
sudo iptables -A FORWARD -j ACCEPT -i $LAN

sudo iptables -A FORWARD -j LOG --log-prefix "[iptables] FORWARD:DROP " --log-level 5 --log-ip-options --log-uid


#================================
# NAT
#================================
sudo iptables -F -t nat
sudo iptables -X -t nat
sudo iptables -Z -t nat

sudo iptables -t nat -P PREROUTING  ACCEPT
sudo iptables -t nat -P POSTROUTING ACCEPT
sudo iptables -t nat -P OUTPUT      ACCEPT

sudo iptables -t nat -A POSTROUTING -s 192.168.254.0/24 -o ppp0 -j MASQUERADE


#================================
# SAVE
#================================
sudo iptables-save
