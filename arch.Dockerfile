FROM archlinux/archlinux:latest

# Update package database and install dependencies including Nix
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm nix curl xz sudo git base-devel && \
    pacman -Scc --noconfirm

# Create a non-root user for Nix
RUN useradd -m -s /bin/bash nixuser && \
    echo 'nixuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create /nix directory with proper permissions
RUN mkdir -p /nix && chown -R nixuser:nixuser /nix

# Switch to non-root user
USER nixuser
WORKDIR /home/nixuser

# Initialize Nix for single-user mode and enable flakes with sandbox disabled
RUN nix-store --init && \
    mkdir -p /home/nixuser/.config/nix && \
    echo 'experimental-features = nix-command flakes' > /home/nixuser/.config/nix/nix.conf && \
    echo 'sandbox = false' >> /home/nixuser/.config/nix/nix.conf && \
    echo 'filter-syscalls = false' >> /home/nixuser/.config/nix/nix.conf

# Add Nix to PATH
ENV PATH="/nix/var/nix/profiles/default/bin:/home/nixuser/.nix-profile/bin:${PATH}"

# Create basic Nix profile directories
RUN mkdir -p /home/nixuser/.nix-profile

# Set up .bashrc for Nix environment
RUN echo 'export PATH="/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:$PATH"' >> /home/nixuser/.bashrc

# Verify Nix installation and flakes support
RUN nix --version && nix flake --help

WORKDIR /app
