#!/usr/bin/env bash

ip tuntap add name tap0 mode tap user root
brctl addbr br0
brctl addif br0 tap0
brctl addif br0 eth0
ip link set tap0 up
ip link set eth0 up
ip link set br0 up

dhcpcd br0

# iptables -t mangle -A PREROUTING -i 172.17.0.2 -p tcp --dport 6970 -j MARK --set-mark 0x1234
# iptables -t nat -A PREROUTING -p tcp -i 172.17.0.2 --dport 6970 -j DNAT --to-destination 192.168.69.1:6970
# iptables -A INPUT -m mark --mark 0x1234 -j ACCEPT

# iptables -t nat -A PREROUTING -i eth0 -j SNAT --to 192.168.69.1
# iptables -t nat -A POSTROUTING -o tap0 -j SNAT --to 172.17.0.2

# iptables -t nat -A PREROUTING -p tcp --dport 6970 -j DNAT --to-destination 192.168.69.1:6970
# iptables -t nat -A POSTROUTING -p tcp -d 172.17.0.2 --dport 6970 -j SNAT --to-source 172.17.0.2

server --tap tap0