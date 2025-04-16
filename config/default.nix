{ pkgs, ... }:
{
  enableMan = false;
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins
  ];

  extraPackages = with pkgs; [
    ripgrep
    lazygit
    fzf
    fd
  ];
}
