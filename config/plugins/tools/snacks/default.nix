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
    ./image.nix
  ];

  plugins = {
    snacks = {
      enable = true;
      settings = {
        win.enabled = true;
        notify.enabled = true;
        terminal.enabled = true;
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
          terminal = {
            wo = {
              winhighlight = "Normal:Normal,NormalNC:NormalNC,NormalFloat:NormalFloat,FloatBorder:FloatBorder,FloatTitle:FloatTitle";
            };
          };
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.snacks.settings.terminal.enabled [
    {
      mode = [
        "n"
        "t"
      ];
      key = "<leader>tt";
      action.__raw = ''
        function()
          Snacks.terminal.toggle(nil, {
            count = 1,
            win = {
              position = "float",
              border = "rounded",
              width = 0.9,
              height = 0.85,
            },
          })
        end
      '';
      options.desc = "Terminal float (toggle)";
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<leader>th";
      action.__raw = ''
        function()
          Snacks.terminal.toggle(nil, {
            count = 2,
            win = {
              position = "bottom",
              height = 0.35,
            },
          })
        end
      '';
      options.desc = "Terminal horizontal (toggle)";
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<leader>tv";
      action.__raw = ''
        function()
          Snacks.terminal.toggle(nil, {
            count = 3,
            win = {
              position = "right",
              width = 0.45,
            },
          })
        end
      '';
      options.desc = "Terminal vertical right (toggle)";
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<leader>tq";
      action.__raw = ''
        function()
          for _, term in ipairs(Snacks.terminal.list()) do
            term:hide()
          end
        end
      '';
      options.desc = "Close all terminals";
    }
  ];
}
