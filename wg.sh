#!/bin/bash

set -xe

export PATH=$PATH:/usr/sbin:/sbin:/usr/bin:/bin

check_root() {
    [[ $EUID -ne 0 ]] && echo "Требуются права root" && exit 1
}

install_wireguard() {
    apt update && apt install -y wireguard iptables-persistent curl
}

enable_ip_forwarding() {
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    sysctl -p
}

setup_wireguard() {
    umask 077
    wg genkey | tee /etc/wireguard/private.key | wg pubkey > /etc/wireguard/public.key
    
    cat > /etc/wireguard/wg0.conf << EOF
[Interface]
Address = 10.10.0.1/24
ListenPort = 51820
PrivateKey = $(cat /etc/wireguard/private.key)
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
SaveConfig = true
EOF
    
    systemctl enable wg-quick@wg0
    systemctl start wg-quick@wg0
}

create_client() {
    echo "Имя клиента: "
    read CLIENT_NAME
    
    CLIENT_PRIVATE=$(wg genkey)
    CLIENT_PUBLIC=$(echo $CLIENT_PRIVATE | wg pubkey)
    
    PEER_COUNT=0
    if wg show wg0 peers &>/dev/null; then
        PEER_COUNT=$(wg show wg0 peers | wc -l)
    fi
    CLIENT_IP="10.10.0.$((PEER_COUNT + 2))"
    
    SERVER_PUBLIC=$(cat /etc/wireguard/public.key)
    SERVER_IP=$(curl -s ifconfig.me)
    
    CLIENT_CONFIG="[Interface]
PrivateKey = $CLIENT_PRIVATE
Address = $CLIENT_IP/24
DNS = 8.8.8.8

[Peer]
PublicKey = $SERVER_PUBLIC
Endpoint = $SERVER_IP:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25"
    
    wg set wg0 peer $CLIENT_PUBLIC allowed-ips $CLIENT_IP/32
    wg-quick save wg0
    
    echo ""
    echo "=========================================="
    echo "Конфиг для подключения клиента $CLIENT_NAME:"
    echo "=========================================="
    echo "$CLIENT_CONFIG"
    echo "=========================================="
    echo ""
    echo "IP клиента: $CLIENT_IP"
    echo "Публичный ключ сервера: $SERVER_PUBLIC"
    echo ""
    
    echo "$CLIENT_CONFIG" > /root/$CLIENT_NAME.conf
    echo "Конфиг также сохранен в /root/$CLIENT_NAME.conf"
}

main() {
    check_root
    install_wireguard
    enable_ip_forwarding
    setup_wireguard
    create_client
}

main
