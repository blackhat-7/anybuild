# anybuild

## Usage

Build the Docker image:
```bash
docker build -t nixer .
```

Run with a Rust hello world example:
```bash
docker run -v ./examples/rust-hello-world:/app/build -it --entrypoint /bin/bash nixer
```

Inside the container, you can then run:
```bash
nix build
nix run
```
