#!/bin/bash

printf "### Starting ZeroTier interface"
printf " "

service zerotier-one start
sleep 5

# fetch ZT_NETWORK specified in balena environment variable, clean whitespaces and commas if any
ZT_NETWORKS="$(echo $ZT_NETWORK | tr -d '[:space:]' | tr ',' '\n')"

# zerotier-cli set $ZT_NETWORK allowManaged=0

# fetch currently joined networks
ZT_CURRENT_NETWORKS="$(zerotier-cli listnetworks -j | jq -r '.[] | (.id)')"

# join networks specified in environment variable,
for ZT_NETWORK in ${ZT_NETWORKS}; do
  if ! echo "$ZT_CURRENT_NETWORKS" | grep -q "$ZT_NETWORK"; then
    echo "Joining $ZT_NETWORK";
    zerotier-cli join $ZT_NETWORK;
  fi
done

# leave networks not specified in environment variable
for ZT_CURRENT_NETWORK in ${ZT_CURRENT_NETWORKS}; do
  if echo "$ZT_NETWORKS" | grep -q "$ZT_CURRENT_NETWORK"; then
    echo "Keeping $ZT_CURRENT_NETWORK";  
  else
    echo "Leaving $ZT_CURRENT_NETWORK";
    zerotier-cli leave $ZT_CURRENT_NETWORK;
  fi
done

PHY_IFACE="$(ip route | grep default | cut -d' ' -f5)"

# cut -f9 returns IP block (or - if no IP address), -f8 will return the network interface
ZT_IFACES="$(zerotier-cli listnetworks -j | jq -r '.[] | (.portDeviceName)')"

sysctl -w net.ipv4.ip_forward=1

# looping for multiple physical interfaces
for IFACE in ${PHY_IFACE//\s/ }; do
  iptables -t nat -A POSTROUTING -o $IFACE -j MASQUERADE
  # looping for multiple ZeroTier interfaces
  for ZT_IFACE in ${ZT_IFACES}; do 
    iptables -A FORWARD -i $ZT_IFACE -o $IFACE -j ACCEPT
    iptables -A FORWARD -i $IFACE -o $ZT_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
  done
done

while true; do
  # brctl show box0 | grep ztbpaltgeu > /dev/null 2>&1
  # if [ "$?" != "0" ]; then
  #   brctl addif box0 ztbpaltgeu
  #   printf "### ZeroTier interface added to bridge"
  # fi
  sleep 5
done