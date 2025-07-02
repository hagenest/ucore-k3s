# Base image (Fedora 40 uCore)
FROM ghcr.io/ublue-os/ucore:latest

# Install required dependencies
RUN rpm-ostree install \
    iptables \
    iproute \
    ipset \
    conntrack-tools \
    ebtables \
    ethtool \
    socat \
    nftables \
    && rpm-ostree cleanup -m

# Set k3s version and download URL
ARG K3S_VERSION=v1.33.2+k3s1
ARG K3S_BIN_URL=https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s

# Download and install k3s binary
RUN curl -sL ${K3S_BIN_URL} -o /usr/local/bin/k3s \
    && chmod 755 /usr/local/bin/k3s

# Create symlinks for k3s utilities
RUN ln -s /usr/local/bin/k3s /usr/local/bin/kubectl \
    && ln -s /usr/local/bin/k3s /usr/local/bin/crictl \
    && ln -s /usr/local/bin/k3s /usr/local/bin/ctr

# Create necessary directories
RUN mkdir -p \
    /etc/rancher/k3s \
    /var/lib/rancher/k3s \
    /var/lib/kubelet \
    /var/log/k3s

# Copy installation scripts and configs
COPY install/ /usr/etc/

# Run post-installation script
RUN /usr/etc/k3s-install.sh

# Set up systemd service
RUN systemctl enable k3s.service

# Cleanup
RUN rm -rf /var/cache/* /tmp/*
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
