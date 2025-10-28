#!/bin/bash

set -euo pipefail

SIC_KEY=$(dotenvx get -f ../.env -fk ../.env.keys TF_VAR_cluster_sic_key)

VERSION="R82"

RG=$(terraform output -raw rg)
CLUSTER_NAME="remote-$(terraform output -raw name)"
NODE1_NAME="remote-ha1"
NODE2_NAME="remote-ha2"

# obtain various IPs from Azure inventory using AZ cli
# Public IPs are ha, ha1_IP and ha2_IP

PIP_DATA=$(az network public-ip list -g "$RG" -o json)
PIP_CLUSTER=$(echo "$PIP_DATA" | jq -r '.[] | select(.name == "ha")| .ipAddress')
PIP_NODE1=$(echo "$PIP_DATA" | jq -r '.[] | select(.name == "ha1_IP")| .ipAddress')
PIP_NODE2=$(echo "$PIP_DATA" | jq -r '.[] | select(.name == "ha2_IP")| .ipAddress')

echo "Cluster Public IP: $PIP_CLUSTER"
echo "Node1 Public IP: $PIP_NODE1"
echo "Node2 Public IP: $PIP_NODE2"
echo 


MAIN_IP="$PIP_CLUSTER"

FRONT_NETMASK="255.255.255.0"
BACK_NETMASK="255.255.255.0"

# there are NIC objects ha1-eth0, ha1-eth1, ha2-eth0, ha2-eth1
# they have own ipconfig1, ipconfig2 and cluster-vip IP configurations

#az network nic list -g "$RG" -o table
#az network nic list -g "$RG" -o json
NIC_DATA=$(az network nic list -g "$RG" -o json)

# echo "$NIC_DATA" | jq -r '.[].ipConfigurations[].name'

VIP_ETH0_IP=$(echo "$NIC_DATA" | jq -r '.[].ipConfigurations[] | select(.name == "cluster-vip").privateIPAddress')

NODE1_ETH0=$(echo "$NIC_DATA" | jq -r '.[] | select(.name == "ha1-eth0").ipConfigurations[]| select(.name == "ipconfig1").privateIPAddress')
NODE2_ETH0=$(echo "$NIC_DATA" | jq -r '.[] | select(.name == "ha2-eth0").ipConfigurations[]| select(.name == "ipconfig1").privateIPAddress')

NODE1_ETH1=$(echo "$NIC_DATA" | jq -r '.[] | select(.name == "ha1-eth1").ipConfigurations[]| select(.name == "ipconfig2").privateIPAddress')
NODE2_ETH1=$(echo "$NIC_DATA" | jq -r '.[] | select(.name == "ha2-eth1").ipConfigurations[]| select(.name == "ipconfig2").privateIPAddress')

cat << EOF
Cluster VIP eth0 IP: $VIP_ETH0_IP
Node1 eth0 IP: $NODE1_ETH0
Node1 eth1 IP: $NODE1_ETH1
Node2 eth0 IP: $NODE2_ETH0
Node2 eth1 IP: $NODE2_ETH1
EOF

cat << EOF

===========================

mgmt_cli -r true add simple-cluster name "$CLUSTER_NAME"\
    color "pink"\
    version "$VERSION"\
    ip-address "${MAIN_IP}"\
    os-name "Gaia"\
    cluster-mode "cluster-xl-ha"\
    firewall true\
    vpn false\
    interfaces.1.name "eth0"\
    interfaces.1.ip-address "${VIP_ETH0_IP}"\
    interfaces.1.network-mask "${FRONT_NETMASK}"\
    interfaces.1.interface-type "cluster + sync"\
    interfaces.1.topology "EXTERNAL"\
    interfaces.1.anti-spoofing false \
    interfaces.2.name "eth1"\
    interfaces.2.interface-type "sync"\
    interfaces.2.topology "INTERNAL"\
    interfaces.2.topology-settings.ip-address-behind-this-interface "network defined by the interface ip and net mask"\
    interfaces.2.topology-settings.interface-leads-to-dmz false\
    interfaces.2.anti-spoofing false \
    members.1.name "$NODE1_NAME"\
    members.1.one-time-password "${SIC_KEY}"\
    members.1.ip-address "${PIP_NODE1}"\
    members.1.interfaces.1.name "eth0"\
    members.1.interfaces.1.ip-address "${NODE1_ETH0}"\
    members.1.interfaces.1.network-mask "${FRONT_NETMASK}"\
    members.1.interfaces.2.name "eth1"\
    members.1.interfaces.2.ip-address "${NODE1_ETH1}"\
    members.1.interfaces.2.network-mask "${BACK_NETMASK}"\
    members.2.name "$NODE2_NAME"\
    members.2.one-time-password "${SIC_KEY}"\
    members.2.ip-address "${PIP_NODE2}"\
    members.2.interfaces.1.name "eth0"\
    members.2.interfaces.1.ip-address "${NODE2_ETH0}"\
    members.2.interfaces.1.network-mask "${FRONT_NETMASK}"\
    members.2.interfaces.2.name "eth1"\
    members.2.interfaces.2.ip-address "${NODE2_ETH1}"\
    members.2.interfaces.2.network-mask "${BACK_NETMASK}"\
    --format json
EOF