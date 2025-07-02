#!/usr/bin/env bash
set -euo pipefail

# Enable k3s service
systemctl enable k3s.service

# Create necessary directories
mkdir -p /etc/rancher/k3s

# Default configuration (customize as needed)
cat > /etc/rancher/k3s/config.yaml <<EOF
write-kubeconfig-mode: "0644"
disable:
  - traefik
  - servicelb
EOF

# Ensure proper permissions
chmod 600 /etc/rancher/k3s/config.yaml

