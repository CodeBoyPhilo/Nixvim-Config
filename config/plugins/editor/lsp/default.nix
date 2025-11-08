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
      enable = false;
    };

    lsp-signature = {
      enable = false;
    };

    lsp-format = {
      enable = false;
    };

    # Main LSP configuration
    lsp = {
      enable = true;
      inlayHints = false;
      luaConfig.pre = ''
        vim.lsp.handlers["$/progress"] = function() end
      '';

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
        ty = {
          enable = true;
        };
        pyrefly = {
          enable = true;
        };
        jedi_language_server = {
          enable = false;
        };
        pylsp = {
          enable = false;
        };
        basedpyright = {
          enable = false;
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
        tinymist = {
          enable = true;
        };
        ltex = {
          enable = true;
          filetypes = [
            "bibtex"
            "html"
            "latex"
            "markdown"
            "typst"
          ];
          settings = {
            language = "en-AU";
          };
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
    {
      mode = "n";
      key = "<leader>ch";
      action.__raw = ''
        function()
          local inlay_hint = vim.lsp.inlay_hint
          if inlay_hint == nil then
            local buf_hint = vim.lsp.buf and vim.lsp.buf.inlay_hint
            if buf_hint == nil then
              vim.notify("Inlay hints not supported", vim.log.levels.WARN)
              return
            end
            inlay_hint = buf_hint
          end

          local bufnr = vim.api.nvim_get_current_buf()

          if type(inlay_hint) == "table" then
            local enabled = inlay_hint.is_enabled({ bufnr = bufnr })
            inlay_hint.enable(not enabled, { bufnr = bufnr })
          else
            local enabled = vim.b.lsp_inlay_hint_enabled
            if enabled == nil then
              enabled = false
            end
            enabled = not enabled
            vim.b.lsp_inlay_hint_enabled = enabled
            inlay_hint(bufnr, enabled)
          end
        end
      '';
      options.desc = "Toggle Inlay Hints";
    }
  ];
}
