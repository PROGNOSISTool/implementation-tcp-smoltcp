#!/usr/bin/env bash

modprobe bridge
modprobe br_netfilter

ip tuntap add name tap0 mode tap user root
brctl addbr br0
brctl addif br0 tap0
brctl addif br0 eth0
ip link set tap0 up
ip link set eth0 up
ip link set br0 up

dhcpcd br0

ip=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
gat=$(ip route | awk '/default via/ { print $3 }')

server --tap tap0 --ip $ip --gat $gat
