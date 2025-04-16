# flake.nix
{
  description = "Philo's NixVim Config";

  inputs = {
    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
    
    blink-cmp = {
      url = "github:saghen/blink.cmp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixvim, flake-utils, nixpkgs, self, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      nixvimLib = nixvim.lib.${system};
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      nixvim' = nixvim.legacyPackages.${system};
      nixvimModule = {
        inherit pkgs;
        module = import ./config; 
        
        extraSpecialArgs = {
          inherit inputs self;
        } // import ./lib { inherit pkgs; };
      };
      nvim = nixvim'.makeNixvimWithModule nixvimModule;
    in {
      checks = {
        default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
      };

      packages.default = nvim;
    });
}
