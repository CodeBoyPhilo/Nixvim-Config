{ lib, config, ... }:
let
  theme = config.theme;
in
{
  imports = [
    ./catppuccin
    ./bufferline
    ./dashboard
    ./dropbar
    ./lualine
    ./noice
    ./notify
    ./nui
    ./numbertoggle
    ./tokyonight
    ./ufo
    ./web-devicons
    ./zen-mode
    ./maple
  ];
  config = {
    assertions = [
      {
        assertion =
          (lib.count (enabled: enabled) [
            theme.catppuccin.enable
            theme.tokyonight.enable
            theme.maple.enable
          ]) == 1;
        message = "Enable exactly one theme (catppuccin, tokyonight, maple).";
      }
    ];
  };
}
