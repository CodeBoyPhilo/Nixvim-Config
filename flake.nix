# Acknowledgement 💡

# This config is deeply inpired by the configs from:
# https://github.com/spector700/Akari
# https://github.com/redyf/Neve
# Parts of their configs are directly applied to my nixvim (copy & paste)

{
  description = "Philo's NixVim Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-latest.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";

    blink-cmp = {
      url = "github:saghen/blink.cmp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixvim,
      flake-utils,
      nixpkgs,
      nixpkgs-latest,
      self,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        nixvimLib = nixvim.lib.${system};
        pkgs-latest = import nixpkgs-latest {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              pyrefly = pkgs-latest.pyrefly;
              ty = pkgs-latest.ty;
							yazi = pkgs-latest.yazi;
            })
          ];
        };
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
          inherit pkgs;
          module = import ./config;

          extraSpecialArgs = {
            inherit inputs self;
          }
          // import ./lib { inherit pkgs; };
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
      in
      {
        checks = {
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        packages.default = nvim;
      }
    );
}
