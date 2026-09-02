{ config, ... }:
{
  plugins = {
    treesitter = {
      enable = true;
      folding.enable = false;
      highlight = {
        enable = true;
        enableVimSyntax = true;
        disable.__raw = ''
          function(_, bufnr)
            return vim.api.nvim_buf_line_count(bufnr) > 10000
          end
        '';
      };

      settings = {
        incremental_selection.enable = true;
        indent.enable = false;
      };
      nixvimInjections = true;
    };

    treesitter-context = {
      inherit (config.plugins.treesitter) enable;
      settings = {
        max_lines = 4;
        min_window_height = 40;
        multiwindow = true;
        separator = "-";
      };
    };

    treesitter-refactor = {
      enable = false;
      # inherit (config.plugins.treesitter) enable;

      settings = {
        highlight_definitions = {
          enable = true;
          clear_on_cursor_move = true;
        };
        smart_rename.enable = true;
        navigation.enable = true;
      };

    };
  };
}
