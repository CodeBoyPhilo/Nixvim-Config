{
  plugins = {
    nvim-ufo = {
      enable = true;
      luaConfig.pre = ''
        vim.o.foldcolumn = "0" -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      '';
      settings = {
        provider_selector = # lua
          ''
            function()
              return { "lsp", "indent" }
            end
          '';
      };
    };
  };
  keymaps = [
    {
      key = "zm";
      mode = "n";
      action.__raw = "function() require('ufo').closeAllFolds() end";
      options.desc = "󱃄 Close All Folds";
    }
    {
      key = "zr";
      mode = "n";
      action.__raw = "function() require('ufo').openFoldsExceptKinds { 'comment', 'imports' }; vim.opt.scrolloff = vim.g.baseScrolloff end";
      options.desc = "󱃄 Open All Regular Folds";
    }
    {
      key = "zR";
      mode = "n";
      action.__raw = "function() require('ufo').openFoldsExceptKinds {} end";
      options.desc = "󱃄 Open All Folds";
    }
    {
      key = "z1";
      mode = "n";
      action.__raw = "function() require('ufo').closeFoldsWith(1) end";
      options.desc = "󱃄 Close Level 1 Folds";
    }
    {
      key = "z2";
      mode = "n";
      action.__raw = "function() require('ufo').closeFoldsWith(2) end";
      options.desc = "󱃄 Close Level 2 Folds";
    }
    {
      key = "z3";
      mode = "n";
      action.__raw = "function() require('ufo').closeFoldsWith(3) end";
      options.desc = "󱃄 Close Level 3 Folds";
    }
    {
      key = "z4";
      mode = "n";
      action.__raw = "function() require('ufo').closeFoldsWith(4) end";
      options.desc = "󱃄 Close Level 4 Folds";
    }
  ];
}
