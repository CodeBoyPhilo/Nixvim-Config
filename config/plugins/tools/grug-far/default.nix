{ pkgs, ... }:
{
  plugins.grug-far = {
    enable = true;
    settings = {
      debounceMs = 500;
      minSearchChars = 2;
      maxSearchMatches = 2000;
      normalModeSearch = false;

      engine = "ripgrep";
      enabledEngines = [
        "ripgrep"
        "astgrep"
        "astgrep-rules"
      ];
      engines = {
        ripgrep = {
          path = "${pkgs.ripgrep}/bin/rg";
          showReplaceDiff = true;
        };
        astgrep = {
          path = "${pkgs.ast-grep}/bin/ast-grep";
        };
        "astgrep-rules" = {
          path = "${pkgs.ast-grep}/bin/ast-grep";
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>rr";
      action = "<cmd>GrugFar<CR>";
      options.desc = "Replace in project";
    }
    {
      mode = "n";
      key = "<leader>rw";
      action.__raw = ''
        function()
          require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
        end
      '';
      options.desc = "Replace word under cursor";
    }
    {
      mode = "n";
      key = "<leader>rf";
      action.__raw = ''
        function()
          require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
        end
      '';
      options.desc = "Replace in current file";
    }
    {
      mode = "n";
      key = "<leader>ra";
      action.__raw = ''
        function()
          require("grug-far").open({ engine = "astgrep" })
        end
      '';
      options.desc = "AST replace";
    }
    {
      mode = "x";
      key = "<leader>rr";
      action.__raw = ''
        function()
          require("grug-far").with_visual_selection()
        end
      '';
      options.desc = "Replace visual selection";
    }
    {
      mode = "x";
      key = "<leader>rR";
      action.__raw = ''
        function()
          require("grug-far").open({ visualSelectionUsage = "operate-within-range" })
        end
      '';
      options.desc = "Replace within visual range";
    }
  ];
}
