{ pkgs, ... }:
{
  enableMan = false;
  imports = [
    ./options.nix
    ./keymaps.nix

    ./plugins/editor
    ./plugins/extras
    ./plugins/tools
    ./plugins/ui
  ];

  extraPackages = with pkgs; [
    ripgrep
    lazygit
    fzf
    fd
  ];

  theme = {
    catppuccin.enable = true;
    tokyonight.enable = false;
  };
}
