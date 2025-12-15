#!/bin/bash

set -e

export PATH=$PATH:/usr/sbin:/sbin:/usr/bin:/bin

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

function get_user_input() {
    echo -e "${GREEN}"
    echo "⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄"
    echo "⠄⠄⠄⠄⠄⠄⠄⣀⡤⠶⠒⠒⠒⠒⠶⢤⣀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣀⡤⠶⠒⠒⠒⠒⠶⢤⣀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣀⡤⠶⠒⠒⠒⠒⠶⢤⣀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣀⡤⠶⠒⠒⠒⠒⠶⢤⣀⠄⠄⠄⠄⠄⠄⠄"
    echo "⠄⠄⠄⠄⢀⡴⠋⠁⠄⠄⠄⠄⠄⠄⠄⠄⠈⠙⢦⡀⠄⠄⠄⠄⠄⠄⠄⠄⢀⡴⠋⠁⠄⠄⠄⠄⠄⠄⠄⠄⠈⠙⢦⡀⠄⠄⠄⠄⠄⠄⠄⠄⢀⡴⠋⠁⠄⠄⠄⠄⠄⠄⠄⠄⠈⠙⢦⡀⠄⠄⠄⠄⠄⠄⠄⠄⢀⡴⠋⠁⠄⠄⠄⠄⠄⠄⠄⠄⠈⠙⢦⡀⠄⠄⠄⠄"
    echo "⠄⠄⠄⢠⠏⠄⢀⣠⣤⣀⠄⠄⠄⣠⠖⠲⣄⠄⠄⠹⡄⠄⠄⠄⠄⠄⠄⢠⠏⠄⢀⣠⣤⣀⠄⠄⠄⣠⠖⠲⣄⠄⠄⠹⡄⠄⠄⠄⠄⠄⠄⢠⠏⠄⢀⣠⣤⣀⠄⠄⠄⣠⠖⠲⣄⠄⠄⠹⡄⠄⠄⠄⠄⠄⠄⢠⠏⠄⢀⣠⣤⣀⠄⠄⠄⣠⠖⠲⣄⠄⠄⠹⡄⠄⠄⠄"
    echo "⠄⠄⢠⡏⠄⠄⠸⠁⠄⠙⠄⠄⠄⠃⠄⠄⠉⠄⠄⠄⢹⡄⠄⠄⠄⠄⢠⡏⠄⠄⠸⠁⠄⠙⠄⠄⠄⠃⠄⠄⠉⠄⠄⠄⢹⡄⠄⠄⠄⠄⢠⡏⠄⠄⠸⠁⠄⠙⠄⠄⠄⠃⠄⠄⠉⠄⠄⠄⢹⡄⠄⠄⠄⠄⢠⡏⠄⠄⠸⠁⠄⠙⠄⠄⠄⠃⠄⠄⠉⠄⠄⠄⢹⡄⠄⠄"
    echo "⠄⠄⢸⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣀⠄⠄⠄⠄⠄⡇⠄⠄⠄⠄⢸⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣀⠄⠄⠄⠄⠄⡇⠄⠄⠄⠄⢸⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣀⠄⠄⠄⠄⠄⡇⠄⠄⠄⠄⢸⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣀⠄⠄⠄⠄⠄⡇⠄⠄"
    echo "⠄⠄⢸⠄⣀⣀⡀⠄⠳⢦⣄⣀⣠⡤⠞⠁⠄⢀⣀⣀⠄⡇⠄⠄⠄⠄⢸⠄⣀⣀⡀⠄⠳⢦⣄⣀⣠⡤⠞⠁⠄⢀⣀⣀⠄⡇⠄⠄⠄⠄⢸⠄⣀⣀⡀⠄⠳⢦⣄⣀⣠⡤⠞⠁⠄⢀⣀⣀⠄⡇⠄⠄⠄⠄⢸⠄⣀⣀⡀⠄⠳⢦⣄⣀⣠⡤⠞⠁⠄⢀⣀⣀⠄⡇⠄⠄"
    echo "⠄⡴⠚⣉⠉⠉⠉⠳⣄⠄⠄⠄⠄⠄⠄⣠⠞⠉⠉⠉⣉⠓⢦⠄⡴⠚⣉⠉⠉⠉⠳⣄⠄⠄⠄⠄⠄⠄⣠⠞⠉⠉⠉⣉⠓⢦⠄⠄⡴⠚⣉⠉⠉⠉⠳⣄⠄⠄⠄⠄⠄⠄⣠⠞⠉⠉⠉⣉⠓⢦⠄⠄⡴⠚⣉⠉⠉⠉⠳⣄⠄⠄⠄⠄⠄⠄⣠⠞⠉⠉⠉⣉⠓⢦⠄⠄"
    echo "⣤⠗⠚⣉⠳⠶⠆⠄⢸⠄⠄⠄⠄⠄⠄⡇⠄⠰⠶⠞⣉⠓⠺⣤⣤⠗⠚⣉⠳⠶⠆⠄⢸⠄⠄⠄⠄⠄⠄⡇⠄⠰⠶⠞⣉⠓⠺⣤⣤⠗⠚⣉⠳⠶⠆⠄⢸⠄⠄⠄⠄⠄⠄⡇⠄⠰⠶⠞⣉⠓⠺⣤⣤⠗⠚⣉⠳⠶⠆⠄⢸⠄⠄⠄⠄⠄⠄⡇⠄⠰⠶⠞⣉⠓⠺⣤"
    echo "⢹⠚⢋⣥⠖⣀⠄⢀⡞⠄⠄⠄⠄⠄⠄⢳⡀⠄⣀⠲⣌⡙⠓⡏⢹⠚⢋⣥⠖⣀⠄⢀⡞⠄⠄⠄⠄⠄⠄⢳⡀⠄⣀⠲⣌⡙⠓⡏⢹⠚⢋⣥⠖⣀⠄⢀⡞⠄⠄⠄⠄⠄⠄⢳⡀⠄⣀⠲⣌⡙⠓⡏⢹⠚⢋⣥⠖⣀⠄⢀⡞⠄⠄⠄⠄⠄⠄⢳⡀⠄⣀⠲⣌⡙⠓⡏"
    echo "⠈⠻⣍⣴⣞⣡⡴⠋⠓⠶⠤⠤⠤⠤⠶⠚⠙⢦⣌⣳⣦⣩⠟⠁⠈⠻⣍⣴⣞⣡⡴⠋⠓⠶⠤⠤⠤⠤⠶⠚⠙⢦⣌⣳⣦⣩⠟⠁⠈⠻⣍⣴⣞⣡⡴⠋⠓⠶⠤⠤⠤⠤⠶⠚⠙⢦⣌⣳⣦⣩⠟⠁⠈⠻⣍⣴⣞⣡⡴⠋⠓⠶⠤⠤⠤⠤⠶⠚⠙⢦⣌⣳⣦⣩⠟⠁"
    echo "⠄⠄⠄⠄⠉⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠈⠉⠄⠄⠄⠄⠄⠄⠄⠄⠉⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠈⠉⠄⠄⠄⠄⠄⠄⠄⠄⠉⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠈⠉⠄⠄⠄⠄⠄⠄⠄⠄⠉⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠈⠉⠄⠄⠄⠄"
    echo -e "${NC}"
    
    echo -e "${GREEN}Welcome to Debian Security Hardening installer!${NC}"
    echo "The script will harden your Debian 12 server with SSH security, UFW, and Fail2ban."
    echo ""
    echo "I need to ask you a few questions before starting the setup."
    echo "You can keep the default options and just press enter if you are ok with them."
    echo ""

    CURRENT_SSH_PORT=$(grep -E "^Port\s+[0-9]+" /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}' | head -1)
    if [[ -z "${CURRENT_SSH_PORT}" ]]; then
        CURRENT_SSH_PORT="22"
    fi
    
    CURRENT_USER=$(who | awk '{print $1}' | grep -v root | head -1)
    if [[ -z "${CURRENT_USER}" ]]; then
        CURRENT_USER="superh0st"
    fi
    
    SERVER_PUB_IP=$(curl -s -4 ifconfig.me 2>/dev/null || curl -s -6 ifconfig.me 2>/dev/null || ip -4 addr | sed -ne 's|^.* inet \([^/]*\)/.* scope global.*$|\1|p' | awk '{print $1}' | head -1)
    
    echo -e "${YELLOW}Network Configuration:${NC}"
    if [[ ! -z "${SERVER_PUB_IP}" ]]; then
        read -rp "Public IP address of this server: " -e -i "${SERVER_PUB_IP}" SERVER_PUB_IP
    else
        read -rp "Public IP address of this server: " SERVER_PUB_IP
    fi

    echo ""
    echo -e "${YELLOW}SSH Configuration:${NC}"
    
    unset SSH_PORT
    until [[ ${SSH_PORT} =~ ^[0-9]+$ ]] && [ "${SSH_PORT}" -ge 1 ] && [ "${SSH_PORT}" -le 65535 ]; do
        read -rp "SSH port [1-65535]: " -e -i "${CURRENT_SSH_PORT}" SSH_PORT
    done
    
    unset USERNAME
    until [[ ${USERNAME} =~ ^[a-z][-a-z0-9_]*$ ]]; do
        read -rp "Username for SSH access: " -e -i "${CURRENT_USER}" USERNAME
        if [[ ! ${USERNAME} =~ ^[a-z][-a-z0-9_]*$ ]]; then
            print_error "Username must start with a lowercase letter and contain only lowercase letters, numbers, hyphens, and underscores."
        fi
    done
    
    read -sp "Password for user ${USERNAME} (hidden input): " USER_PASSWORD
    echo ""
    if [[ -z "${USER_PASSWORD}" ]]; then
        USER_PASSWORD='Pa$$word123'
        echo "Using default password"
    fi
    
    echo ""
    echo -e "${YELLOW}Security Options:${NC}"
    read -rp "Allow SSH root login? (yes/no): " -e -i "no" ALLOW_ROOT_LOGIN
    if [[ ${ALLOW_ROOT_LOGIN} =~ ^(yes|y)$ ]]; then
        ALLOW_ROOT_LOGIN="yes"
    else
        ALLOW_ROOT_LOGIN="no"
    fi
    
    read -rp "Enable password authentication? (yes/no): " -e -i "yes" PASSWORD_AUTH
    if [[ ${PASSWORD_AUTH} =~ ^(no|n)$ ]]; then
        PASSWORD_AUTH="no"
    else
        PASSWORD_AUTH="yes"
    fi
    
    echo ""
    echo -e "${YELLOW}Firewall and Intrusion Detection:${NC}"
    
    read -rp "Install and configure UFW firewall? (yes/no): " -e -i "yes" INSTALL_UFW
    if [[ ${INSTALL_UFW} =~ ^(no|n)$ ]]; then
        INSTALL_UFW="false"
    else
        INSTALL_UFW="true"
    fi
    
    read -rp "Install and configure Fail2ban? (yes/no): " -e -i "yes" INSTALL_FAIL2BAN
    if [[ ${INSTALL_FAIL2BAN} =~ ^(no|n)$ ]]; then
        INSTALL_FAIL2BAN="false"
    else
        INSTALL_FAIL2BAN="true"
    fi

    if [[ "${INSTALL_UFW}" == "true" ]]; then
        echo ""
        echo "Additional ports to open in firewall (comma separated, e.g., 80,443,3000):"
        read -rp "Extra ports: " -e -i "80,443" EXTRA_PORTS
    fi
    
    if [[ "${INSTALL_FAIL2BAN}" == "true" ]]; then
        echo ""
        read -rp "Email for Fail2ban notifications (optional): " ADMIN_EMAIL
    fi
    
    echo ""
    read -rp "Update system packages? (yes/no): " -e -i "yes" UPDATE_SYSTEM
    if [[ ${UPDATE_SYSTEM} =~ ^(no|n)$ ]]; then
        UPDATE_SYSTEM="false"
    else
        UPDATE_SYSTEM="true"
    fi
    
    echo ""
    echo -e "${GREEN}Configuration Summary:${NC}"
    echo "========================================="
    echo "SSH Port: ${SSH_PORT}"
    echo "Username: ${USERNAME}"
    echo "Allow Root Login: ${ALLOW_ROOT_LOGIN}"
    echo "Password Authentication: ${PASSWORD_AUTH}"
    echo "Install UFW: ${INSTALL_UFW}"
    echo "Install Fail2ban: ${INSTALL_FAIL2BAN}"
    
    if [[ "${INSTALL_UFW}" == "true" ]] && [[ ! -z "${EXTRA_PORTS}" ]]; then
        echo "Extra Firewall Ports: ${EXTRA_PORTS}"
    fi
    
    if [[ "${INSTALL_FAIL2BAN}" == "true" ]] && [[ ! -z "${ADMIN_EMAIL}" ]]; then
        echo "Admin Email: ${ADMIN_EMAIL}"
    fi
    
    echo "Update System: ${UPDATE_SYSTEM}"
    echo "========================================="
    echo ""
    
    read -rp "Is this configuration correct? (yes/no): " -e -i "yes" CONFIRM_CONFIG
    if [[ ${CONFIRM_CONFIG} =~ ^(yes|y)$ ]]; then
        echo ""
        echo "Starting installation..."
        echo ""
    else
        print_error "Configuration cancelled. Run the script again to reconfigure."
        exit 1
    fi
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "Этот скрипт должен запускаться с правами root"
        exit 1
    fi
}

update_system() {
    print_info "Обновление списка пакетов и системы..."
    apt update && apt upgrade -y
}

create_user() {
    local username="$1"
    local password="$2"
    
    print_info "Создание пользователя $username..."
    
    if id "$username" &>/dev/null; then
        print_warning "Пользователь $username уже существует"
    else
        useradd -m -s /bin/bash -p "$(openssl passwd -6 "$password")" "$username"
        usermod -aG sudo "$username"
        print_info "Пользователь $username создан и добавлен в группу sudo"
        echo "Password for $username: $password" | tee /root/user_credentials.txt
    fi
}

configure_ssh() {
    local ssh_port="$1"
    local allow_root="$2"
    local password_auth="$3"
    
    print_info "Настройка SSH на порт $ssh_port..."
    
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
    
    local root_login="no"
    if [[ "$allow_root" == "yes" ]]; then
        root_login="yes"
    fi
    
    local pubkey_auth="yes"
    if [[ "$password_auth" == "yes" ]]; then
        pubkey_auth="yes"
    fi
    
    cat > /etc/ssh/sshd_config << EOF
Include /etc/ssh/sshd_config.d/*.conf
KbdInteractiveAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
UseDNS no
AcceptEnv LANG LC_*
Subsystem       sftp    /usr/lib/openssh/sftp-server

Port $ssh_port
PermitRootLogin $root_login
PubkeyAuthentication $pubkey_auth
PasswordAuthentication $password_auth
ChallengeResponseAuthentication no
EOF
    
    print_info "SSH сконфигурирован на порт $ssh_port"
    print_info "PermitRootLogin: $root_login"
    print_info "PasswordAuthentication: $password_auth"
}

setup_ufw() {
    local ssh_port="$1"
    local install_ufw="$2"
    local extra_ports="$3"
    
    if [ "$install_ufw" = "false" ]; then
        print_warning "Пропуск установки UFW по выбору пользователя"
        return
    fi
    
    print_info "Установка и настройка UFW..."
    
    if ! command -v ufw &> /dev/null; then
        apt install ufw -y
    fi
    
    ufw --force reset
    ufw default deny incoming
    ufw default allow outgoing
    
    # Открываем SSH порт
    ufw allow "$ssh_port/tcp"
    
    if [[ ! -z "$extra_ports" ]]; then
        IFS=',' read -ra PORTS <<< "$extra_ports"
        for port in "${PORTS[@]}"; do
            port=$(echo "$port" | xargs)
            if [[ "$port" =~ ^[0-9]+$ ]]; then
                ufw allow "$port/tcp"
                print_info "Port $port/tcp открыт в UFW"
            fi
        done
    fi
    
    ufw --force enable
    sleep 2
    
    print_info "Статус UFW:"
    ufw status verbose
}

install_fail2ban_package() {
    local install_fail2ban="$1"
    
    if [ "$install_fail2ban" = "false" ]; then
        print_warning "Пропуск установки Fail2ban по выбору пользователя"
        return
    fi
    
    print_info "Установка Fail2ban..."
    apt install fail2ban -y
}

configure_fail2ban() {
    local ssh_port="$1"
    local install_fail2ban="$2"
    local admin_email="$3"
    
    if [ "$install_fail2ban" = "false" ]; then
        return
    fi
    
    print_info "Настройка Fail2ban..."
    
    cat > /etc/fail2ban/jail.local << EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 4
action = %(action_mwl)s
ignoreip = 127.0.0.1/8 ::1
backend = systemd
EOF
    
    if [[ ! -z "$admin_email" ]]; then
        cat >> /etc/fail2ban/jail.local << EOF
destemail = $admin_email
sender = root@$(hostname -f)
mta = sendmail
action = %(action_mwl)s
EOF
    fi
    
    cat >> /etc/fail2ban/jail.local << EOF

[sshd]
enabled = true
port = $ssh_port
filter = sshd
logpath = /var/log/auth.log
maxretry = 4
bantime = 86400

[sshd-ddos]
enabled = true
port = $ssh_port
filter = sshd-ddos
logpath = /var/log/auth.log
maxretry = 2
bantime = 604800
EOF
    
    print_warning "/etc/fail2ban/jail.local настроен"
}

setup_fail2ban_ufw() {
    local install_fail2ban="$1"
    local install_ufw="$2"
    
    if [ "$install_fail2ban" = "false" ] || [ "$install_ufw" = "false" ]; then
        return
    fi
    
    print_info "Настройка интеграции Fail2ban с UFW..."
    
    cat > /etc/fail2ban/filter.d/ufw.conf << 'EOF'
[Definition]
failregex = \[UFW BLOCK\].*SRC=<HOST>
ignoreregex =
EOF
    
    cat >> /etc/fail2ban/jail.local << EOF

[ufw]
enabled = true
filter = ufw
action = ufw
logpath = /var/log/ufw.log
maxretry = 1
bantime = 2592000
EOF
}

enable_services() {
    local install_fail2ban="$1"
    local ssh_port="$2"
    
    print_info "Перезапуск служб..."
    
    systemctl restart ssh
    
    if [ "$install_fail2ban" = "true" ]; then
        systemctl enable fail2ban
        systemctl restart fail2ban
        
        print_info "Проверка статуса Fail2ban..."
        systemctl status fail2ban --no-pager
    fi
    
    print_info "SSH служба перезапущена на порту $ssh_port"
}

verify_installation() {
    local ssh_port="$1"
    local install_fail2ban="$2"
    
    print_info "Проверка установки..."
    
    print_info "Проверка SSH порта $ssh_port:"
    if ss -tlnp | grep -q ":$ssh_port "; then
        print_info "✓ SSH слушает порт $ssh_port"
    else
        print_error "✗ SSH не слушает порт $ssh_port"
    fi
    
    if [ "$install_fail2ban" = "true" ]; then
        print_info "Проверка Fail2ban..."
        if systemctl is-active --quiet fail2ban; then
            print_info "✓ Fail2ban активен"
            fail2ban-client --version
            print_info "Статус jails:"
            fail2ban-client status
        else
            print_error "✗ Fail2ban не активен"
        fi
    fi
}

install_utils() {
    print_info "Установка дополнительных утилит..."
    apt install -y whois net-tools curl wget
}

print_summary() {
    local ssh_port="$1"
    local username="$2"
    local install_ufw="$3"
    local install_fail2ban="$4"
    local server_ip="$5"
    
    print_info "=================================================="
    print_info "Установка и настройка завершена!"
    print_info "=================================================="
    echo ""
    print_warning "ВАЖНО:"
    echo "1. SSH теперь работает на порту $ssh_port"
    echo "2. Создан пользователь $username с sudo правами"
    echo "3. Пароль пользователя сохранен в /root/user_credentials.txt"
    
    if [ "$install_ufw" = "true" ]; then
        echo "4. UFW установлен и настроен"
    fi
    
    if [ "$install_fail2ban" = "true" ]; then
        echo "5. Fail2ban установлен и настроен"
        echo "   Конфиг: /etc/fail2ban/jail.local"
    fi
    
    echo ""
    print_info "Для подключения используйте:"
    if [[ ! -z "$server_ip" ]]; then
        echo "  ssh -p $ssh_port $username@$server_ip"
    else
        echo "  ssh -p $ssh_port $username@ваш_сервер_ip"
    fi
    
    echo ""
    print_info "Полезные команды для мониторинга:"
    echo "  sudo systemctl status ssh"
    
    if [ "$install_fail2ban" = "true" ]; then
        echo "  sudo fail2ban-client status sshd"
        if [ "$install_ufw" = "true" ]; then
            echo "  sudo fail2ban-client status ufw"
        fi
        echo "  sudo tail -f /var/log/fail2ban.log"
    fi
    
    if [ "$install_ufw" = "true" ]; then
        echo "  sudo ufw status verbose"
    fi
    
    echo ""
    print_warning "Рекомендуется:"
    echo "1. Проверить подключение SSH с нового порта"
    echo "2. Настроить SSH ключи для более безопасного доступа"
    echo "3. Регулярно обновлять систему: sudo apt update && sudo apt upgrade"
}

main() {
    clear
    
    get_user_input
    
    check_root
    
    if [[ "$UPDATE_SYSTEM" == "true" ]]; then
        update_system
    fi
    
    create_user "$USERNAME" "$USER_PASSWORD"
    configure_ssh "$SSH_PORT" "$ALLOW_ROOT_LOGIN" "$PASSWORD_AUTH"
    setup_ufw "$SSH_PORT" "$INSTALL_UFW" "$EXTRA_PORTS"
    install_fail2ban_package "$INSTALL_FAIL2BAN"
    configure_fail2ban "$SSH_PORT" "$INSTALL_FAIL2BAN" "$ADMIN_EMAIL"
    setup_fail2ban_ufw "$INSTALL_FAIL2BAN" "$INSTALL_UFW"
    install_utils
    enable_services "$INSTALL_FAIL2BAN" "$SSH_PORT"
    verify_installation "$SSH_PORT" "$INSTALL_FAIL2BAN"
    print_summary "$SSH_PORT" "$USERNAME" "$INSTALL_UFW" "$INSTALL_FAIL2BAN" "$SERVER_PUB_IP"
}

main
