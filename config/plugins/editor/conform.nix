{ pkgs, lib, ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      # format_on_save = ''
      #   function(bufnr)
      #     -- Disable with a global or buffer-local variable
      #     if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      #       return
      #     end
      #     return { timeout_ms = 500, lsp_format = 'fallback' }
      #   end
      # '';
      notify_on_error = true;
      formatters_by_ft = {
        # Common filetypes
        html = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        python = [
          "black"
          "isort"
        ];
        lua = [ "stylua" ];
        nix = [ "nixfmt-rfc-style" ];
        markdown = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        bash = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        json = [ "jq" ];
        # Formatter for all filetypes
        "_" = [ "trim_whitespace" ];
      };

      formatters = {
        black = {
          command = "${lib.getExe pkgs.black}";
        };
        isort = {
          command = "${lib.getExe pkgs.isort}";
        };
        nixfmt-rfc-style = {
          command = "${lib.getExe pkgs.nixfmt-rfc-style}";
        };
        jq = {
          command = "${lib.getExe pkgs.jq}";
        };
        prettierd = {
          command = "${lib.getExe pkgs.prettierd}";
        };
        stylua = {
          command = "${lib.getExe pkgs.stylua}";
        };
        shellcheck = {
          command = "${lib.getExe pkgs.shellcheck}";
        };
        shfmt = {
          command = "${lib.getExe pkgs.shfmt}";
        };
        shellharden = {
          command = "${lib.getExe pkgs.shellharden}";
        };
      };
    };
  };

  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>mp";
      action = "<cmd>lua require('conform').format()<cr>";
      options = {
        silent = true;
        desc = "Format";
      };
    }
  ];
}
