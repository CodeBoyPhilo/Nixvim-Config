{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./dashboard.nix
    ./indent.nix
    ./bigfile.nix
    ./lazygit.nix
  ];

  plugins = {
    snacks = {
      enable = true;
      settings = {
        win.enabled = true;
        notify.enabled = true;
        notifier = {
          enabled = true;
          timeout = 3000;
        };
        styles = {
          notification = {
            wo = {
              wrap = true;
            };
          };
        };
      };
    };
  };
}
