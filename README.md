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
curl -fsSL https://your-domain.com | bash
```

Or:

```bash
wget -qO- https://your-domain.com | bash
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

### GitHub + Cloudflare Pages

1. Fork this repository
2. Create a new project in Cloudflare Pages
3. Connect your GitHub repository
4. Configure build settings:
   - Build command: (leave empty)
   - Build output directory: `public`
5. Update `public/_redirects` with your GitHub username (change `oroliy` to your username)
6. Deploy and bind your custom domain

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

Inspired by [bench.sh](https://github.com/llitfkitfb/bench.sh)
