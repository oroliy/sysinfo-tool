#!/usr/bin/env bash
# GitHub Pages installer - fetches and runs the actual script
# This file is served directly by GitHub Pages

if command -v curl >/dev/null 2>&1; then
    exec curl -fsSL https://raw.githubusercontent.com/oroliy/sysinfo-tool/main/script/sysinfo.sh | bash
elif command -v wget >/dev/null 2>&1; then
    exec wget -qO- https://raw.githubusercontent.com/oroliy/sysinfo-tool/main/script/sysinfo.sh | bash
else
    echo "Error: curl or wget is required to install sysinfo.sh." >&2
    exit 1
fi
