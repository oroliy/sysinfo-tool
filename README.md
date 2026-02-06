# sysinfo.sh

A lightweight system information tool inspired by [bench.sh](https://github.com/llitfkitfb/bench.sh), focusing on essential system metrics without network speed testing.

## Features

- **CPU Information**: Model, cores, and frequency
- **Memory Information**: RAM and Swap usage
- **Disk Information**: Total and used disk space
- **OS Information**: Distribution, kernel version, architecture
- **System Uptime**: How long the system has been running
- **Load Average**: 1, 5, and 15 minute load averages
- **Virtualization**: Detects VM type (KVM, Xen, OpenVZ, etc.)
- **Network Connectivity**: IPv4 and IPv6 connection status

## Quick Install

Run with one command:

```bash
curl -fsSL https://oroliy.github.io/sysinfo-tool/install.sh | bash
```

Or:

```bash
wget -qO- https://oroliy.github.io/sysinfo-tool/install.sh | bash
```

## Manual Download

```bash
curl -fsSL https://raw.githubusercontent.com/oroliy/sysinfo-tool/main/script/sysinfo.sh -o sysinfo.sh
chmod +x sysinfo.sh
./sysinfo.sh
```

## Supported Systems

- Debian 10+
- Ubuntu 18.04+
- CentOS/RHEL 7+
- Alpine Linux 3.12+
- Arch Linux
- Rocky Linux
- AlmaLinux
- macOS (limited support)

## Project Structure

```
sysinfo-tool/
├── script/
│   └── sysinfo.sh           # Main script
├── public/
│   └── _redirects           # Cloudflare Pages redirect configuration
├── LICENSE
└── README.md
```

## Deployment

### GitHub Pages (Recommended)

This repository is configured to automatically deploy to GitHub Pages via GitHub Actions.

1. Fork this repository
2. Go to Settings > Pages
3. Source: GitHub Actions
4. The workflow will automatically deploy on push

### Fork Your Own

To deploy your own copy:

1. Fork this repository
2. Edit `public/install.sh` and replace `oroliy` with your username
3. Edit `public/index.html` and update the redirect URLs
4. Enable GitHub Pages in repository settings
5. GitHub Actions will automatically deploy your site

Your URL will be: `https://YOUR_USERNAME.github.io/sysinfo-tool/install.sh`

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

Inspired by [bench.sh](https://github.com/llitfkitfb/bench.sh)
