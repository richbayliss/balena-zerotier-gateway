#!/bin/bash

printf "### Starting ZeroTier interface"

service zerotier-one start
sleep 5
zerotier-cli join $ZT_NETWORK
# zerotier-cli set $ZT_NETWORK allowManaged=0

PHY_IFACE="$(ip route | grep default | cut -d' ' -f5)"
ZT_IFACE="$(zerotier-cli listnetworks | tail -n1 | cut -d' ' -f9)"

sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o $PHY_IFACE -j MASQUERADE
sudo iptables -A FORWARD -i $ZT_IFACE -o $PHY_IFACE -j ACCEPT
sudo iptables -A FORWARD -i $PHY_IFACE -o $ZT_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT

while true; do
  # brctl show box0 | grep ztbpaltgeu > /dev/null 2>&1
  # if [ "$?" != "0" ]; then
  #   brctl addif box0 ztbpaltgeu
  #   printf "### ZeroTier interface added to bridge"
  # fi
  sleep 5
done
