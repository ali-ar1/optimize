#!/bin/bash

echo "=== Starting Full Optimize Install (v2) ==="

# 1. آپدیت و آپگرید
echo "[*] Updating system..."
apt-get update -y && apt-get upgrade -y || echo "[!] apt upgrade failed"

# 2. جایگزینی sysctl.conf
echo "[*] Applying sysctl.conf ..."
cat > /etc/sysctl.conf << 'EOF'
# NotePadVPN Optimize
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.core.rmem_default = 16777216
net.core.wmem_default = 16777216
net.core.netdev_max_backlog = 30000
net.core.netdev_budget = 600
net.core.netdev_budget_usecs = 8000
net.core.somaxconn = 32768
net.core.dev_weight = 128
net.core.bpf_jit_enable = 1
net.core.bpf_jit_kallsyms = 1
net.core.bpf_jit_harden = 0

net.ipv4.tcp_rmem = 8192 131072 134217728
net.ipv4.tcp_wmem = 8192 131072 134217728
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_ecn = 2
net.ipv4.tcp_syncookies = 1

net.ipv4.ip_forward = 1
net.ipv4.ip_default_ttl = 64

vm.swappiness = 10
vm.overcommit_memory = 1
vm.max_map_count = 262144
fs.file-max = 2097152
net.core.default_qdisc = fq_codel
EOF

sysctl -p || echo "[!] sysctl reload had warnings (ignored)"

# 3. دانلود optimize.sh
echo "[*] Installing optimize.sh ..."
mkdir -p /opt/ar/optimize
wget -q -O /opt/ar/optimize/optimize.sh https://raw.githubusercontent.com/ali-ar1/optimize/main/optimize.sh && chmod +x /opt/ar/optimize/optimize.sh
[[ -f /opt/ar/optimize/optimize.sh ]] && echo "[OK] optimize.sh installed" || echo "[!] optimize.sh missing"

# 4. اجرای optimize
/opt/ar/optimize/optimize.sh -i eth0 || echo "[!] optimize -i failed"
/opt/ar/optimize/optimize.sh -s || echo "[!] optimize -s failed"

# 5. ساخت tc_optimize.sh
echo "[*] Creating tc_optimize.sh ..."
cat > /usr/local/bin/tc_optimize.sh << 'EOF'
#!/bin/bash
INTERFACE=$(ip route get 8.8.8.8 | awk '/dev/ {print $5; exit}')
tc qdisc del dev $INTERFACE root 2>/dev/null
tc qdisc del dev $INTERFACE ingress 2>/dev/null
ip link set dev $INTERFACE mtu 1500 2>/dev/null
echo 1000 > /sys/class/net/$INTERFACE/tx_queue_len 2>/dev/null
if tc qdisc add dev $INTERFACE root cake bandwidth 1000mbit rtt 20ms nat dual-dsthost 2>/dev/null; then
    echo "$(date): CAKE optimization complete" >> /var/log/tc_smart.log
elif tc qdisc add dev $INTERFACE root fq_codel limit 10240 flows 1024 target 5ms interval 100ms 2>/dev/null; then
    echo "$(date): FQ_CoDel optimization complete" >> /var/log/tc_smart.log
else
    tc qdisc add dev $INTERFACE root netem delay 1ms loss 0.005% duplicate 0.05% reorder 0.5% 2>/dev/null
    echo "$(date): Fallback Netem optimization complete" >> /var/log/tc_smart.log
fi
tc qdisc show dev $INTERFACE | grep -E 'cake|fq_codel|htb|netem'
echo -e "\033[38;5;208m@NotePadVpn\033[0m"
EOF

chmod +x /usr/local/bin/tc_optimize.sh
(crontab -l 2>/dev/null; echo "@reboot sleep 30 && /usr/local/bin/tc_optimize.sh") | crontab -

# 6. تست اسکریپت
/usr/local/bin/tc_optimize.sh && echo "[OK] tc_optimize.sh ran successfully"

# 7. سواپ‌فایل
echo "[*] Creating 4G swapfile ..."
fallocate -l 4G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=4096
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
grep -qF '/swapfile none swap sw 0 0' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
sysctl vm.swappiness=40
echo 'vm.swappiness=40' >> /etc/sysctl.conf
(crontab -l 2>/dev/null; echo "CRON_TZ=Asia/Tehran 30 3 * * * /sbin/reboot") | crontab -

# 8. نصب کرنل xanmod
echo "[*] Checking architecture for xanmod kernel..."
ARCH=$(awk -f <(wget -qO - https://dl.xanmod.org/check_x86-64_psabi.sh) 2>/dev/null | grep -o 'x86-64-v[1-4]' | tail -1)
if [[ -n "$ARCH" ]]; then
    wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /etc/apt/keyrings/xanmod-archive-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' > /etc/apt/sources.list.d/xanmod-release.list
    apt update
    case $ARCH in
        x86-64-v1) KERNEL_PKG="linux-xanmod-lts-x64v1" ;;
        x86-64-v2) KERNEL_PKG="linux-xanmod-x64v2" ;;
        x86-64-v3|x86-64-v4) KERNEL_PKG="linux-xanmod-x64v3" ;;
    esac
    echo "[*] Installing kernel: $KERNEL_PKG ..."
    apt install --no-install-recommends -y clang lld llvm libelf-dev dkms $KERNEL_PKG
    echo "[OK] Kernel installed, system will reboot in 10s"
    sleep 10
    reboot
else
    echo "[!] Unsupported architecture, skipping xanmod kernel"
fi

echo "=== Install Completed ==="
