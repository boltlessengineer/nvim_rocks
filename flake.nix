{
  description = "My Neovim config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }: flake-parts.lib.mkFlake {inherit inputs;} {
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    perSystem = { system, pkgs, ... }: {
      devShells.default = pkgs.mkShell {
        name = "NativeVim devShell";
        buildInputs = [
          pkgs.neovim
          pkgs.sumneko-lua-language-server
          pkgs.stylua
        ];
      };
    };
  };
}
# vim: set ts=2:
