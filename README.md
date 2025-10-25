# anybuild

A collection of Docker images with Nix pre-installed for cross-platform building using Nix flakes.

## Available Images

This project provides Dockerfiles for multiple Linux distributions:

- **Ubuntu 20.04** (`ubuntu.Dockerfile`)
- **Arch Linux** (`arch.Dockerfile`)

## Usage

### Ubuntu

Build the Ubuntu-based Docker image:
```bash
docker build -f ubuntu.Dockerfile -t nixer-ubuntu .
```

Run with a Rust hello world example:
```bash
docker run -v ./examples/rust-hello-world:/app/build -it --entrypoint /bin/bash nixer-ubuntu
```

### Arch Linux

Build the Arch Linux-based Docker image:
```bash
docker build -f arch.Dockerfile -t nixer-arch .
```

Run with a Rust hello world example:
```bash
docker run -v ./examples/rust-hello-world:/app/build -it --entrypoint /bin/bash nixer-arch
```

### Building and Running Projects

Inside either container, you can then run:
```bash
nix build
nix run
```

Both images come with Nix flakes and experimental features enabled by default, allowing you to build any Nix flake project regardless of your host operating system.

## Features

- Non-root user setup for security
- Nix package manager with flakes support
- Experimental features enabled (nix-command, flakes)
- Clean, minimal base images
- Cross-platform compatibility

## Examples

The `examples/` directory contains sample projects that demonstrate how to use these Docker images with different types of Nix flakes.