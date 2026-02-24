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
		lsof
  ];

  theme = {
    catppuccin.enable = false;
    tokyonight.enable = false;
    maple.enable = true;
  };
}
