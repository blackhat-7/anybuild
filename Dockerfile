FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl xz-utils sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user for Nix
RUN useradd -m -s /bin/bash nixuser && \
    echo 'nixuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to non-root user and install Nix
USER nixuser
WORKDIR /home/nixuser

# Install Nix
RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

# Create nix config directory and enable experimental features
RUN mkdir -p /home/nixuser/.config/nix && \
    echo 'experimental-features = nix-command flakes' > /home/nixuser/.config/nix/nix.conf

# Source nix profile for future commands
ENV PATH="/home/nixuser/.nix-profile/bin:${PATH}"
RUN echo '. /home/nixuser/.nix-profile/etc/profile.d/nix.sh' >> /home/nixuser/.bashrc

WORKDIR /app
