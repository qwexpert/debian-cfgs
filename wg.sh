#!/bin/bash

set -e

export PATH=$PATH:/usr/sbin:/sbin:/usr/bin:/bin

setup_wg() {
    apt update
    apt install -y wireguard

    wg genkey | tee /etc/wireguard/sk | wg pubkey | tee /etc/wireguard/pk

    SK=$(cat /etc/wireguard/sk)
    PK=$(cat /etc/wireguard/pk)
    IP="10.20.30.1"
    PORT="51820"
    
    cat > /etc/wireguard/wg0.conf << EOF
[Interface]
Address = $IP/24
ListenPort = $PORT
PrivateKey = $SK
PostUp = /usr/sbin/iptables -A FORWARD -i ens3 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE 
PostDown = /usr/sbin/iptables -D FORWARD -i ens3 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE

# [Peer]
# PublicKey = 
# AllowedIPs = 10.20.30.2/32
EOF

    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p

    ufw allow 51820/udp comment 'wg-quick@wg0'
    
    cat >> /etc/ufw/before.rules << EOF
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -s 10.20.30.0/24 -o ens3 -j MASQUERADE
COMMIT
EOF
    sed -i '/^DEFAULT_FORWARD_POLICY/s/DROP/ACCEPT/' /etc/default/ufw

    systemctl enable wg-quick@wg0
    systemctl start wg-quick@wg0
}

main() {
    setup_wg
    
    echo "WireGuard запущен"
    echo "Публичный ключ: $(cat /etc/wireguard/public.key)"
}

main
