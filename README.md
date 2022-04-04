# ZeroTier Router on Balena

## How to use:
- create a new fleet on Balena https://balena.io
- create a network on ZeroTier https://my.zerotier.com/
- copy the network ID (e.g. abcd12ef3456gh78)
- update the application variables on Balena, add:
  - `ZT_NETWORK` = ZeroTier network ID
- push this repository to your balena application
- add a device to your Balena fleet
- wait until the device has started and is running the application
- on the ZeroTier dashboard, approve the device and copy it's assigned ZeroTier IP address
- in the Managed Routes seciton of the ZeroTier dashboard,
  - add a route to `0.0.0.0/0` via the new device' assigned ZeroTier address
- add more clients to your ZeroTier network
  - they can now use the connection as their default route

## Tested on:
- Raspberry Pi 3B+ running BalenaOS 2.95.8
  - ZeroTier version 1.8.7

