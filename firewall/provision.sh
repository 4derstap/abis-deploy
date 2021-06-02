#!/bin/bash

# Ensure that IPv6 is enabled or the start of snmpd fails.
sysctl net.ipv6.conf.all.disable_ipv6=0
sed -i 's/net.ipv6.conf.all.disable_ipv6.*=.*/net.ipv6.conf.all.disable_ipv6 = 0/' /etc/sysctl.conf

# Ensure that the firewall allows access to the ABIS Backend service endpoints.
# cp abisbackend.xml /etc/firewalld/services
firewall-cmd --reload
firewall-cmd --zone=public --add-service=abisbackend
firewall-cmd --runtime-to-permanent
