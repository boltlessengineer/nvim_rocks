{
  description = "My Neovim config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
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
    perSystem = { system, ... }: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (self: super: {
            neovim-nightly = inputs.neovim-nightly-overlay.packages.${system}.default;
          })
        ];
      };
    in {
      devShells.default = pkgs.mkShell {
        name = "NativeVim (stable) devShell";
        buildInputs = [
          pkgs.neovim
          pkgs.sumneko-lua-language-server
          pkgs.stylua
        ];
      };
      devShells.nightly = pkgs.mkShell {
        name = "NativeVim (nightly) devShell";
        buildInputs = [
          pkgs.vim
          pkgs.neovim-nightly
          pkgs.sumneko-lua-language-server
          pkgs.stylua
        ];
      };
    };
  };
}
# vim: set ts=2:
