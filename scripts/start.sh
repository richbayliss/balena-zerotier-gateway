#!/bin/bash

printf "### Starting ZeroTier interface"

service zerotier-one start
sleep 5
zerotier-cli join $ZT_NETWORK
zerotier-cli set $ZT_NETWORK allowManaged=0

while true; do
  brctl show box0 | grep ztbpaltgeu > /dev/null 2>&1
  if [ "$?" != "0" ]; then
    brctl addif box0 ztbpaltgeu
    printf "### ZeroTier interface added to bridge"
  fi
  sleep 5
done
