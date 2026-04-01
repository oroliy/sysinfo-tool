#!/usr/bin/env bash
set -euo pipefail

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

check_contains() {
    local needle="$1"
    local file="$2"
    if ! grep -Fq "$needle" "$file"; then
        echo "missing: $needle" >&2
        return 1
    fi
}

TERM=xterm ./script/sysinfo.sh > "$tmpdir/sysinfo-output.txt"

while IFS= read -r pattern; do
    check_contains "$pattern" "$tmpdir/sysinfo-output.txt"
done <<'EOF'
cpu
memory
disk
os
uptime
load avg
virt
ipv4
ipv6
EOF

check_contains 'id="lang-toggle"' public/index.html
check_contains 'id="copy-btn"' public/index.html
check_contains 'id="copy-status"' public/index.html
check_contains '<script src="./lang-toggle.js"></script>' public/index.html
check_contains "const copyStatus = document.getElementById('copy-status');" public/lang-toggle.js
check_contains "copyIdle: '复制'" public/lang-toggle.js
check_contains "copySuccess: '已复制'" public/lang-toggle.js
check_contains "copyError: '复制失败'" public/lang-toggle.js
check_contains "copyIdle: 'Copy'" public/lang-toggle.js
check_contains "copySuccess: 'Copied'" public/lang-toggle.js
check_contains "copyError: 'Copy failed'" public/lang-toggle.js
check_contains 'grep -qE "cpu[[:space:]]"' .github/workflows/test-sysinfo.yml
check_contains 'grep -qE "load avg[[:space:]]"' .github/workflows/test-sysinfo.yml
check_contains 'grep -qE "virt[[:space:]]"' .github/workflows/test-sysinfo.yml
check_contains 'grep -qE "ipv4[[:space:]]"' .github/workflows/test-sysinfo.yml
check_contains 'grep -qE "ipv6[[:space:]]"' .github/workflows/test-sysinfo.yml
