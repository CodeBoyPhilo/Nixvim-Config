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
    ./tagbar
    ./tokyonight
    ./ufo
    ./web-devicons
    ./zen-mode
  ];

  config = {
    assertions = [
      {
        assertion = theme.catppuccin.enable != theme.tokyonight.enable;
        message = "Enable exactly one theme (catppuccin or tokyonight).";
      }
    ];
  };
}
