#!/usr/bin/env bash
# GitHub Pages installer - redirects to the actual script
# This file is served directly by GitHub Pages

exec curl -fsSL https://raw.githubusercontent.com/oroliy/sysinfo-tool/main/script/sysinfo.sh | bash
