#!/bin/bash
set -euo pipefail
umask 077

OUTPUT_DIR="${1:-./evidence_$(hostname)}"

log() {
    echo "[+] $*"
}

prepare_output() {
    if [[ -L "$OUTPUT_DIR" || ( -e "$OUTPUT_DIR" && ! -d "$OUTPUT_DIR" ) ]]; then
        echo "Error: evidence destination must be a real directory: $OUTPUT_DIR" >&2
        return 1
    fi
    mkdir -p -- "$OUTPUT_DIR"/{network,processes,system,persistence,logs}
    chmod 700 "$OUTPUT_DIR" "$OUTPUT_DIR"/{network,processes,system,persistence,logs}
}

collect_network() {
    log "Collecting network evidence"
    ss -tlnp > "$OUTPUT_DIR/network/listening_ports.txt"
    ss -tunap > "$OUTPUT_DIR/network/all_connections.txt"
    netstat -rn > "$OUTPUT_DIR/network/routing_table.txt"
    ip addr > "$OUTPUT_DIR/network/ip_addresses.txt"
    iptables-save > "$OUTPUT_DIR/network/iptables_rules.txt" 2>/dev/null || true
    nft list ruleset > "$OUTPUT_DIR/network/nftables_rules.txt" 2>/dev/null || true
    resolvectl status > "$OUTPUT_DIR/network/dns_config.txt" 2>/dev/null || true
    cat /etc/resolv.conf > "$OUTPUT_DIR/network/resolv.conf" 2>/dev/null || true
}

collect_processes() {
    log "Collecting process evidence"
    ps aux --forest > "$OUTPUT_DIR/processes/process_tree.txt"
    ps aux --sort=-%cpu > "$OUTPUT_DIR/processes/cpu_top.txt"
    ps aux --sort=-%mem > "$OUTPUT_DIR/processes/memory_top.txt"
    systemctl list-units --type=service --state=running > "$OUTPUT_DIR/processes/services.txt"
    ls -la /etc/systemd/system/ > "$OUTPUT_DIR/processes/systemd_units.txt" 2>/dev/null || true
    crontab -l > "$OUTPUT_DIR/processes/crontab.txt" 2>/dev/null || true
    for user in $(getent passwd | cut -d: -f1); do
        crontab -u "$user" -l 2>/dev/null >> "$OUTPUT_DIR/processes/crontabs_all.txt" || true
    done
}

collect_system() {
    log "Collecting system evidence"
    uname -a > "$OUTPUT_DIR/system/kernel.txt"
    cat /etc/os-release > "$OUTPUT_DIR/system/os.txt"
    df -h > "$OUTPUT_DIR/system/disks.txt"
    mount > "$OUTPUT_DIR/system/mounts.txt"
    lsmod > "$OUTPUT_DIR/system/kernel_modules.txt"
    dmesg --level=err,warn > "$OUTPUT_DIR/system/dmesg_errors.txt" 2>/dev/null || true
    getent passwd > "$OUTPUT_DIR/system/users.txt"
    getent group > "$OUTPUT_DIR/system/groups.txt"
    cat /etc/sudoers > "$OUTPUT_DIR/system/sudoers.txt" 2>/dev/null || true
    ls -la /home/ > "$OUTPUT_DIR/system/home_dirs.txt"
    last -100 > "$OUTPUT_DIR/system/last_logins.txt"
    lastb -100 > "$OUTPUT_DIR/system/failed_logins.txt" 2>/dev/null || true
    who -a > "$OUTPUT_DIR/system/current_users.txt"
}

collect_persistence() {
    log "Collecting persistence evidence"
    ls -la /etc/init.d/ > "$OUTPUT_DIR/persistence/initd.txt" 2>/dev/null || true
    ls -la /etc/rc*.d/ > "$OUTPUT_DIR/persistence/rcd.txt" 2>/dev/null || true
    ls -la /etc/profile.d/ > "$OUTPUT_DIR/persistence/profiled.txt" 2>/dev/null || true
    cat /etc/ld.so.preload > "$OUTPUT_DIR/persistence/ld_preload.txt" 2>/dev/null || true
    ls -la ~/.ssh/ > "$OUTPUT_DIR/persistence/ssh_authorized.txt" 2>/dev/null || true
    cat ~/.ssh/authorized_keys > "$OUTPUT_DIR/persistence/authorized_keys.txt" 2>/dev/null || true
}

collect_logs() {
    log "Collecting log evidence"
    cp /var/log/auth.log "$OUTPUT_DIR/logs/auth.log" 2>/dev/null || true
    cp /var/log/syslog "$OUTPUT_DIR/logs/syslog" 2>/dev/null || true
    cp /var/log/kern.log "$OUTPUT_DIR/logs/kern.log" 2>/dev/null || true
    journalctl -u ssh --since "7 days ago" > "$OUTPUT_DIR/logs/ssh_logs.txt" 2>/dev/null || true
    journalctl -u fail2ban --since "7 days ago" > "$OUTPUT_DIR/logs/fail2ban.txt" 2>/dev/null || true
    journalctl --since "7 days ago" | grep -i "fail\|error\|denied\|unauthorized" \
        > "$OUTPUT_DIR/logs/error_highlights.txt" 2>/dev/null || true
}

hash_artifacts() {
    log "Generating file hashes"
    local manifest="$OUTPUT_DIR/hashes.txt"
    find "$OUTPUT_DIR" -type f ! -path "$manifest" -print0 \
        | sort -z \
        | xargs -0 -r sha256sum > "$manifest"
    echo "Hash file: $OUTPUT_DIR/hashes.txt"
}

create_archive() {
    local archive="${OUTPUT_DIR}.tar.gz"
    if [[ -e "$archive" || -L "$archive" ]]; then
        echo "Error: refusing to overwrite existing evidence archive: $archive" >&2
        return 1
    fi
    tar -czf "$archive" -C "$(dirname "$OUTPUT_DIR")" -- "$(basename "$OUTPUT_DIR")"
    log "Evidence archive created: $archive"
    log "SHA256: $(sha256sum "$archive" | cut -d' ' -f1)"
}

main() {
    prepare_output
    collect_network
    collect_processes
    collect_system
    collect_persistence
    collect_logs
    hash_artifacts
    create_archive

    log "Evidence collection completed"
    echo "Evidence directory: $OUTPUT_DIR"
    echo "Evidence archive: ${OUTPUT_DIR}.tar.gz"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main
fi
