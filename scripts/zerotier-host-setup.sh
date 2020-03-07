#!/bin/bash

# This script could be replaced with proper base image preparation, and edit of /etc/NetworkManager/system-connections in SD-Card
# In the meantime, this script has to be executed on all host devices that will receive this ZeroTier container

printf "### Starting Balena host bridge setup"

# The bridge name must not start with br*, because balena's default config is to exclude br* from networkmanager as reported here : https://forums.balena.io/t/bridged-network-configuration/2325/11
nmcli con add ifname box0 type bridge con-name box0
# We dont create a new slave-connection, but modify the default one, and add it to the new bridge.
# Thank you Dan for the trick : https://mail.gnome.org/archives/networkmanager-list/2016-January/msg00053.html
nmcli con mod "Wired connection 1" connection.slave-type bridge connection.master box0
nmcli con modify box0 connection.autoconnect-slaves 1
nmcli con modify box0 bridge.stp no
# The following instructions MUST be initiatied in a single line. If not, it will break the network configuration and brick the device.
nmcli con down box0 ; nmcli con down "Wired connection 1" ; nmcli con up box0


# This "bug" should have been fixed in balena according to this issue : https://github.com/balena-os/meta-balena/issues/958
# But still confirmed mandatory in balenaOS 2.46.1+rev3
iptables -A FORWARD -i box0 -j ACCEPT
iptables -A FORWARD -o box0 -j ACCEPT

printf "### Finished Balena host bridge setup"
