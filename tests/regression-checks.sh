#!/usr/bin/env bash
set -euo pipefail

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

check_contains() {
    local needle="$1"
    local file="$2"
    if ! grep -Fq -- "$needle" "$file"; then
        echo "missing: $needle" >&2
        return 1
    fi
}

check_not_contains() {
    local needle="$1"
    local file="$2"
    if grep -Fq -- "$needle" "$file"; then
        echo "unexpected: $needle" >&2
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

disk_line="$(sed -r 's/\x1B\[[0-9;]*[A-Za-z]//g' "$tmpdir/sysinfo-output.txt" | grep 'disk')"
if [[ "$disk_line" == *'0.00 GB / 0.00 GB'* ]]; then
    echo "unexpected disk line: $disk_line" >&2
    exit 1
fi
if [[ ! "$disk_line" =~ [1-9][0-9]*\.[0-9]{2}\ GB\ /\ [1-9][0-9]*\.[0-9]{2}\ GB ]]; then
    echo "unexpected disk line: $disk_line" >&2
    exit 1
fi

check_contains 'id="lang-toggle"' public/index.html
check_contains 'class="page-shell"' public/index.html
check_contains 'class="hero-grid"' public/index.html
check_contains 'id="eyebrow"' public/index.html
check_contains 'id="hero-title"' public/index.html
check_contains 'id="hero-description"' public/index.html
check_contains 'id="copy-btn"' public/index.html
check_contains 'id="copy-status"' public/index.html
check_contains 'id="download-meta"' public/index.html
check_contains 'id="preview-label"' public/index.html
check_contains 'id="preview-panel"' public/index.html
check_contains '<script src="./lang-toggle.js"></script>' public/index.html
check_contains '--paper:' public/index.html
check_contains '@media (max-width: 860px)' public/index.html
check_contains "const copyStatus = document.getElementById('copy-status');" public/lang-toggle.js
check_contains "const eyebrow = document.getElementById('eyebrow');" public/lang-toggle.js
check_contains "const heroTitle = document.getElementById('hero-title');" public/lang-toggle.js
check_contains "const heroDescription = document.getElementById('hero-description');" public/lang-toggle.js
check_contains "copyIdle: '复制'" public/lang-toggle.js
check_contains "copySuccess: '已复制'" public/lang-toggle.js
check_contains "copyError: '复制失败'" public/lang-toggle.js
check_contains "copyIdle: 'Copy'" public/lang-toggle.js
check_contains "copySuccess: 'Copied'" public/lang-toggle.js
check_contains "copyError: 'Copy failed'" public/lang-toggle.js
check_contains "return 'en';" public/lang-toggle.js
check_contains 'grep -qE "cpu[[:space:]]"' .github/workflows/test-sysinfo.yml
check_contains 'grep -qE "load avg[[:space:]]"' .github/workflows/test-sysinfo.yml
check_contains 'grep -qE "virt[[:space:]]"' .github/workflows/test-sysinfo.yml
check_contains 'grep -qE "ipv4[[:space:]]"' .github/workflows/test-sysinfo.yml
check_contains 'grep -qE "ipv6[[:space:]]"' .github/workflows/test-sysinfo.yml
check_contains 'url=/sysinfo-tool/' public/404.html
check_contains "window.location.href = '/sysinfo-tool/';" public/404.html
check_contains 'if command -v curl >/dev/null 2>&1; then' public/install.sh
check_contains 'elif command -v wget >/dev/null 2>&1; then' public/install.sh
check_contains 'exec wget -qO- https://raw.githubusercontent.com/oroliy/sysinfo-tool/main/script/sysinfo.sh | bash' public/install.sh
