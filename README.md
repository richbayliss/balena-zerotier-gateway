This repo contains a working config of a ZeroTier container in BRIDGE configuration for Balena Cloud platform.
Bridge configuration means your remote devices will be sharing the same LAN, and will act like if sitting next to the home network.
ZeroTier technology is great because you don't need to setup any port forward or NAT to run a private and secure VPN.

This container has been tested in a raspberry 4 but should work on any other platform as long as "balenalib/%%BALENA_MACHINE_NAME%%:latest" is applicable.



High-level guidelines for new comers :

1- Create a ZeroTier account on https://my.zerotier.com
2- Create a private network and write down its ID
3- Add a managed route mapped exactly to your LAN network (eg. 192.168.1.0/24)
4- Configure an IP auto-assign range mapped to a part of your LAN network. (eg. 192.168.1.200 - 192.168.1.250). This range will be assigned to remote devices by ZeroTier's DHCP.
5- To avoid any issues, review your LAN's DHCP/router configuration and assign him another range (eg. 192.168.1.10 - 192.168.1.199). Overlaps must be avoided
6- Create an account on https://www.balena.io/cloud
7- Setup a new balena application
8- Flash your sbc SD card with a generated image
9- Turn on the device and be sure it's online in Balena dashboard
10- To avoid zombie state, pin the device to the factory or latest release
11- Edit and push this repo to your balena application
12- Add your ZeroTier network ID as a "Device Service Variable" named ZT_NETWORK
13- Host system preparation : SSH into the host system and execute zerotier-host-setup.sh. For increased control, you can also type the 8 commands manually.
14- Unpin the device release and monitor container download and startup
15- After a couple of minutes, a new "Not Authorized" member should appear in your ZeroTier dashboard.
16- Before authorizing this new member, be sure to tick "Allow Bridging" and "Do Not Auto Assign IPs". This last option will let your local DHCP assign an IP to your container's ZeroTier interface.
17- Use any mobile or device not connected to your LAN, install ZeroTier client, connect to the same network ID, authorize this member WITHOUT "Allow Bridging" and "Do Not Auto Assign IPs" features. They must stay UNticked.
