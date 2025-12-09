#!/bin/bash

set -ex

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

setup_tap_tunnel() {
    print_info "Настройка Plain TAP Tunnel ..."
    
    apt install socat -y
    
    TAP_IF="tapudp"
    TAP_IP="10.0.100.1"
    TAP_PORT="1194"
    
    ip link del $TAP_IF 2>/dev/null || true
    
    ip tuntap add mode tap dev $TAP_IF
    ip addr add $TAP_IP/24 dev $TAP_IF
    ip link set $TAP_IF up
    
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
    
    iptables -t nat -A POSTROUTING -s 10.0.100.0/24 -j MASQUERADE
    iptables -A FORWARD -i $TAP_IF -j ACCEPT
    iptables -A FORWARD -o $TAP_IF -m state --state RELATED,ESTABLISHED -j ACCEPT
    
    ufw allow $TAP_PORT/udp
    
    cat > /etc/systemd/system/tap-tunnel.service << EOF
[Unit]
Description=Plain TAP Tunnel
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/socat UDP4-LISTEN:$TAP_PORT,fork TAP:$TAP_IP/24,tun-name=$TAP_IF,iff-up
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable tap-tunnel
    systemctl start tap-tunnel
    
    print_info "Plain TAP Tunnel запущен на порту $TAP_PORT"
    print_info "TAP интерфейс: $TAP_IF ($TAP_IP)"
    print_info "Клиентский IP: 10.0.100.2-254"
    
    SERVER_IP=$(hostname -I | awk '{print $1}')
    print_info "На Windows используйте:"
    echo ""
    echo "1. Установите TAP драйвер из OpenVPN"
    echo "2. Скачайте socat для Windows"
    echo "3. Запустите команду:"
    echo "----------------------------------------"
    echo "socat.exe TUN:10.0.100.2/24,tun-type=tap,iff-up UDP4:$SERVER_IP:$TAP_PORT"
    echo "----------------------------------------"
    echo ""
    echo "ИЛИ для проброса конкретных портов:"
    echo "netsh interface portproxy add v4tov4 listenport=27015 connectport=$TAP_PORT connectaddress=$SERVER_IP"
}

main() {
    print_info "Запуск настройки TAP туннеля..."
    setup_tap_tunnel
    print_info "Готово! Проверьте: systemctl status tap-tunnel"
}

main
