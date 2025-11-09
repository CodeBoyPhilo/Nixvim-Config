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
      luaConfig.post = ''
        local util = vim.lsp.util

        local function open_declaration_in_tab(bufnr)
          local params = util.make_position_params()

          vim.lsp.buf_request(bufnr, "textDocument/declaration", params, function(err, result, ctx, _)
            if err then
              local message = (type(err) == "table" and err.message) or tostring(err)
              vim.notify("LSP declaration failed: " .. message, vim.log.levels.ERROR)
              return
            end

            if not result or vim.tbl_isempty(result) then
              vim.notify("No declaration found", vim.log.levels.INFO)
              return
            end

            if not vim.tbl_islist(result) then
              result = { result }
            end

            local function open_location(location)
              local uri = location.targetUri or location.uri
              local range = location.targetSelectionRange or location.range
              if not uri then
                return false
              end

              local filename = vim.uri_to_fname(uri)
              if not filename or filename == "" then
                return false
              end

              vim.cmd("tabnew " .. vim.fn.fnameescape(filename))
              local win = vim.api.nvim_get_current_win()
              local buf = vim.api.nvim_win_get_buf(win)

              if range then
                local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id) or nil
                local encoding = client and client.offset_encoding or "utf-16"
                local col = util._get_line_byte_from_position(buf, range.start, encoding)
                if not col then
                  col = range.start.character
                end
                vim.api.nvim_win_set_cursor(win, { range.start.line + 1, math.max(col, 0) })
              else
                vim.api.nvim_win_set_cursor(win, { 1, 0 })
              end

              vim.cmd("normal! zv")
              return true
            end

            for _, loc in ipairs(result) do
              if open_location(loc) then
                return
              end
            end

            local items = util.locations_to_items(result, ctx and ctx.client_id or nil)
            if not items or vim.tbl_isempty(items) then
              return
            end

            local item = items[1]
            vim.cmd("tabnew " .. vim.fn.fnameescape(item.filename))
            vim.api.nvim_win_set_cursor(0, { item.lnum, math.max(item.col - 1, 0) })
            vim.cmd("normal! zv")
          end)
        end

        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(event)
            vim.schedule(function()
              vim.keymap.set("n", "gD", function()
                open_declaration_in_tab(vim.api.nvim_get_current_buf())
              end, { buffer = event.buf, desc = "Goto Declaration (new tab)", silent = true })
            end)
          end,
        })
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
