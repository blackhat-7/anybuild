{
  description = "Rust Hello World - self-contained";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "hello-world";
          version = "0.1.0";

          src = pkgs.runCommand "rust-src" {} ''
            mkdir -p $out
            cd $out
            ${pkgs.cargo}/bin/cargo init --name hello-world
            cat > src/main.rs << 'EOF'
fn main() {
    println!("Hello, World from Nix!");
}
EOF
          '';

          nativeBuildInputs = with pkgs; [ cargo rustc ];

          buildPhase = ''
            cargo build --release
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp target/release/hello-world $out/bin/
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ cargo rustc ];
        };
      });
}
