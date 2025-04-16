{
  self,
  pkgs,
  lib,
  ...
}:
{
  plugins = {
    # LSP-related plugins
    lsp-lines = {
      enable = true;
    };

    lsp-signature = {
      enable = true;
    };

    lsp-format = {
      enable = true;
    };

    # Main LSP configuration
    lsp = {
      enable = true;
      inlayHints = true;

      # Server configurations
      servers = {
        html = {
          enable = true;
        };
        lua_ls = {
          enable = true;
        };
        ruff = {
          enable = true;
        };
        pyright = {
          enable = true;
        };
        jsonls = {
          enable = true;
        };
        dockerls = {
          enable = true;
        };

        nixd = {
          enable = true;
          settings =
            let
              flake = ''(builtins.getFlake "${self}")'';
              system = ''''${builtins.currentSystem}'';
            in
            {
              formatting = {
                command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
              };
              nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
              options = {
                nixvim.expr = ''${flake}.packages.${system}.nvim.options'';
                # Uncomment and modify these if you have NixOS or Darwin configurations
                # nix-darwin.expr = ''${flake}.darwinConfigurations.<hostname>.options'';
                # nixos.expr = ''${flake}.nixosConfigurations.<hostname>.options'';
                # home-manager.expr = ''${nixos.expr}.home-manager.users.type.getSubOptions [ ]'';
              };
            };
        };

        marksman = {
          enable = true;
        };
        texlab = {
          enable = true;
        };
      };

      # LSP keymaps
      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
        };
        diagnostic = {
          "<leader>cd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>cl";
      action = "<cmd>LspInfo<cr>";
      options.desc = "Lsp Info";
    }
  ];
}
