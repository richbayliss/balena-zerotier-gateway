#!/bin/bash

printf "### Starting ZeroTier interface"

service zerotier-one start
sleep 5
zerotier-cli join $ZT_NETWORK
# zerotier-cli set $ZT_NETWORK allowManaged=0

PHY_IFACE="$(ip route | grep default | cut -d' ' -f5)"

# cut -f9 returns IP block (or - if no IP address), -f8 will return the network interface
ZT_IFACE="$(zerotier-cli listnetworks | tail -n1 | cut -d' ' -f8)"

sysctl -w net.ipv4.ip_forward=1

# looping for multiple physical interfaces
for IFACE in ${PHY_IFACE//\s/ }; do
  iptables -t nat -A POSTROUTING -o $IFACE -j MASQUERADE
  iptables -A FORWARD -i $ZT_IFACE -o $IFACE -j ACCEPT
  iptables -A FORWARD -i $IFACE -o $ZT_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
done

while true; do
  # brctl show box0 | grep ztbpaltgeu > /dev/null 2>&1
  # if [ "$?" != "0" ]; then
  #   brctl addif box0 ztbpaltgeu
  #   printf "### ZeroTier interface added to bridge"
  # fi
  sleep 5
done
