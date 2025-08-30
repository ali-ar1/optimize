#!/bin/bash
set -e

# 1. آپدیت و آپگرید
apt-get update -y && apt-get upgrade -y

# 2. جایگزینی sysctl.conf
cat > /etc/sysctl.conf << 'EOF'
#Freak_4L
#NotePadVPN
#Telegram
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.core.rmem_default = 16777216
net.core.wmem_default = 16777216
net.core.netdev_max_backlog = 30000
net.core.netdev_budget = 600
net.core.netdev_budget_usecs = 8000
net.core.somaxconn = 32768
net.core.dev_weight = 128
net.core.dev_weight_rx_bias = 1
net.core.dev_weight_tx_bias = 1
net.core.bpf_jit_enable = 1
net.core.bpf_jit_kallsyms = 1
net.core.bpf_jit_harden = 0
net.core.flow_limit_cpu_bitmap = 255
net.core.flow_limit_table_len = 8192

net.ipv4.tcp_rmem = 8192 131072 134217728
net.ipv4.tcp_wmem = 8192 131072 134217728
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_fastopen_blackhole_timeout_sec = 0
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_reuse_delay = 100
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_ecn = 2
net.ipv4.tcp_syn_retries = 3
net.ipv4.tcp_synack_retries = 3
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_orphan_retries = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_mtu_probing = 2
net.ipv4.tcp_base_mss = 1024
net.ipv4.tcp_min_snd_mss = 48
net.ipv4.tcp_mtu_probe_floor = 48
net.ipv4.tcp_probe_threshold = 8
net.ipv4.tcp_probe_interval = 600
net.ipv4.tcp_adv_win_scale = 2
net.ipv4.tcp_app_win = 31
net.ipv4.tcp_tso_win_divisor = 8
net.ipv4.tcp_limit_output_bytes = 1048576
net.ipv4.tcp_challenge_ack_limit = 1000
net.ipv4.tcp_autocorking = 1
net.ipv4.tcp_min_tso_segs = 8
net.ipv4.tcp_tso_rtt_log = 9
net.ipv4.tcp_pacing_ss_ratio = 120
net.ipv4.tcp_pacing_ca_ratio = 110
net.ipv4.tcp_reordering = 3
net.ipv4.tcp_max_reordering = 32
net.ipv4.tcp_recovery = 1
net.ipv4.tcp_early_retrans = 3
net.ipv4.tcp_frto = 2
net.ipv4.tcp_thin_linear_timeouts = 1
net.ipv4.tcp_min_rtt_wlen = 300
net.ipv4.tcp_comp_sack_delay_ns = 500000
net.ipv4.tcp_comp_sack_slack_ns = 50000
net.ipv4.tcp_comp_sack_nr = 44
net.ipv4.tcp_notsent_lowat = 131072
net.ipv4.tcp_invalid_ratelimit = 250
net.ipv4.tcp_reflect_tos = 1
net.ipv4.tcp_abort_on_overflow = 0
net.ipv4.tcp_fwmark_accept = 1
net.ipv4.tcp_l3mdev_accept = 1
net.ipv4.tcp_migrate_req = 1
net.ipv4.tcp_syn_linear_timeouts = 4
net.ipv4.tcp_shrink_window = 0
net.ipv4.tcp_workaround_signed_windows = 0

net.ipv4.ip_forward = 1
net.ipv4.ip_default_ttl = 64
net.ipv4.ip_no_pmtu_disc = 0
net.ipv4.ip_forward_use_pmtu = 1
net.ipv4.fwmark_reflect = 1
net.ipv4.fib_multipath_use_neigh = 1
net.ipv4.fib_multipath_hash_policy = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.log_martians = 0
net.ipv4.conf.default.log_martians = 0
net.ipv4.icmp_echo_ignore_all = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.icmp_ratelimit = 100
net.ipv4.icmp_ratemask = 6168

net.netfilter.nf_conntrack_max = 1048576
net.netfilter.nf_conntrack_tcp_timeout_established = 432000
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 30
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_syn_sent = 60
net.netfilter.nf_conntrack_tcp_timeout_syn_recv = 30
net.netfilter.nf_conntrack_udp_timeout = 30
net.netfilter.nf_conntrack_udp_timeout_stream = 120
net.netfilter.nf_conntrack_icmp_timeout = 30
net.netfilter.nf_conntrack_generic_timeout = 120
net.netfilter.nf_conntrack_buckets = 262144
net.netfilter.nf_conntrack_checksum = 0
net.netfilter.nf_conntrack_tcp_be_liberal = 1
net.netfilter.nf_conntrack_tcp_loose = 1

vm.swappiness = 10
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
vm.dirty_expire_centisecs = 1500
vm.dirty_writeback_centisecs = 500
vm.vfs_cache_pressure = 50
vm.min_free_kbytes = 131072
vm.page_cluster = 0
vm.overcommit_memory = 1
vm.overcommit_ratio = 80
vm.max_map_count = 262144
vm.mmap_min_addr = 65536
vm.zone_reclaim_mode = 0
vm.stat_interval = 1

kernel.sched_latency_ns = 6000000
kernel.sched_min_granularity_ns = 1500000
kernel.sched_wakeup_granularity_ns = 2000000
kernel.sched_migration_cost_ns = 500000
kernel.sched_nr_migrate = 64
kernel.sched_tunable_scaling = 0
kernel.sched_child_runs_first = 0
kernel.sched_energy_aware = 1
kernel.sched_schedstats = 0
kernel.sched_rr_timeslice_ms = 25
kernel.sched_rt_period_us = 1000000
kernel.sched_rt_runtime_us = 950000
kernel.sched_cfs_bandwidth_slice_us = 5000
kernel.sched_autogroup_enabled = 1

fs.file-max = 2097152
fs.nr_open = 2097152
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 256
fs.inotify.max_queued_events = 32768
fs.aio-max-nr = 1048576
fs.pipe-max-size = 4194304

net.core.default_qdisc = fq_codel
net.unix.max_dgram_qlen = 512
EOF

# 3. اعمال تغییرات
sysctl -p

# 4. پوشه و دانلود اسکریپت optimize
mkdir -p /opt/ar/optimize
wget -O /opt/ar/optimize/optimize.sh https://raw.githubusercontent.com/ali-ar1/optimize/main/optimize.sh
chmod +x /opt/ar/optimize/optimize.sh

# 5. اجرای optimize
/opt/ar/optimize/optimize.sh -i eth0
/opt/ar/optimize/optimize.sh -s

# 6. ساخت اسکریپت tc_optimize.sh
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
elif tc qdisc add dev $INTERFACE root handle 1: htb default 11 2>/dev/null && \
     tc class add dev $INTERFACE parent 1: classid 1:1 htb rate 1000mbit ceil 1000mbit 2>/dev/null && \
     tc class add dev $INTERFACE parent 1:1 classid 1:11 htb rate 1000mbit ceil 1000mbit 2>/dev/null && \
     tc qdisc add dev $INTERFACE parent 1:11 netem delay 1ms loss 0.005% duplicate 0.05% reorder 0.5% 2>/dev/null; then
    echo "$(date): HTB+Netem optimization complete" >> /var/log/tc_smart.log
else
    tc qdisc add dev $INTERFACE root netem delay 1ms loss 0.005% duplicate 0.05% reorder 0.5% 2>/dev/null
    echo "$(date): Fallback Netem optimization complete" >> /var/log/tc_smart.log
fi

tc qdisc show dev $INTERFACE | grep -E 'cake|fq_codel|htb|netem'
echo -e "\033[38;5;208m@NotePadVpn\033[0m"
EOF

chmod +x /usr/local/bin/tc_optimize.sh
(crontab -l 2>/dev/null; echo "@reboot sleep 30 && /usr/local/bin/tc_optimize.sh") | crontab -

# 7. تست اسکریپت
/usr/local/bin/tc_optimize.sh && echo "Script test successful" && tail -5 /var/log/tc_smart.log

# 8. سواپ‌فایل 8 گیگی
fallocate -l 8G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=8192
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
grep -qF '/swapfile none swap sw 0 0' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
sysctl vm.swappiness=40
echo 'vm.swappiness=40' >> /etc/sysctl.conf
(crontab -l 2>/dev/null; echo "0 3 * * * /sbin/reboot") | crontab -

# 9. نصب کرنل xanmod
ARCH=$(awk -f <(wget -qO - https://dl.xanmod.org/check_x86-64_psabi.sh) 2>/dev/null | grep -o 'x86-64-v[1-4]' | tail -1)
echo "Detected architecture: $ARCH"
if [[ -z "$ARCH" ]]; then
    echo "Error: Could not detect architecture"
    exit 1
fi

apt update && apt upgrade -y
wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /etc/apt/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' > /etc/apt/sources.list.d/xanmod-release.list
apt update

if [[ "$ARCH" == "x86-64-v1" ]]; then
    KERNEL_PKG="linux-xanmod-lts-x64v1"
elif [[ "$ARCH" == "x86-64-v2" ]]; then
    KERNEL_PKG="linux-xanmod-x64v2"
elif [[ "$ARCH" == "x86-64-v3" ]]; then
    KERNEL_PKG="linux-xanmod-x64v3"
elif [[ "$ARCH" == "x86-64-v4" ]]; then
    KERNEL_PKG="linux-xanmod-x64v3"
    echo "Note: Using x64v3 kernel for v4"
else
    echo "Unsupported architecture"
    exit 1
fi

echo "Installing kernel: $KERNEL_PKG"
apt install --no-install-recommends -y clang lld llvm libelf-dev dkms $KERNEL_PKG
echo "Installation completed. System will reboot in 10 seconds..."
sleep 10
reboot
