{
  description = "C Hello World - self-contained";

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

          src = pkgs.runCommand "c-src" {} ''
            mkdir -p $out
            cat > $out/hello.c << 'EOF'
#include <stdio.h>

int main() {
    printf("Hello, World from Nix!\n");
    return 0;
}
EOF
          '';

          nativeBuildInputs = with pkgs; [ gcc ];

          buildPhase = ''
            gcc -o hello-world hello.c
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp hello-world $out/bin/
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ gcc gdb ];
        };
      });
}
