# Base image (Fedora 40 uCore)
FROM ghcr.io/ublue-os/ucore:40

# Add Rancher's k3s repository
RUN curl -sL https://copr.fedorainfracloud.org/coprs/rancher/k3s/repo/fedora-40/rancher-k3s-fedora-40.repo | tee /etc/yum.repos.d/rancher-k3s.repo

# Install k3s and dependencies
RUN rpm-ostree install \
    k3s \
    kernel-modules-extra \
    && rpm-ostree cleanup -m

# Copy installation scripts and configs
COPY install/ /usr/etc/

# Run post-installation script
RUN /usr/etc/k3s-install.sh
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
