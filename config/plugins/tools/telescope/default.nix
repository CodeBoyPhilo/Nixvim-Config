{
  plugins = {
    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
        live-grep-args.enable = true;
      };

      settings.defaults = {
        prompt_prefix = "   ";
        color_devicons = true;
        set_env.COLORTERM = "truecolor";
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "^aux/"
          "^.nvim/"
          "%.ipynb"
        ];

      };
    };
  };
  keymaps = [
    {
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<CR>";
      mode = "n";
      options.desc = "Fuzzy find files in cwd";
    }
    {
      key = "<leader>fr";
      action = "<cmd>Telescope oldfiles<CR>";
      mode = "n";
      options.desc = "Fuzzy find recent files";
    }
    {
      key = "<leader>fs";
      action = "<cmd>Telescope live_grep<CR>";
      mode = "n";
      options.desc = "Find string in cwd";
    }
    {
      key = "<leader>fc";
      action = "<cmd>Telescope grep_string<CR>";
      mode = "n";
      options.desc = "Find string under cursor in cwd";
    }
    {
      key = "<leader>ft";
      action = "<cmd>TodoTelescope<CR>";
      mode = "n";
      options.desc = "Find todos";
    }
    {
      key = "<leader>fp";
      action = "<cmd>Telescope projects<CR>";
      mode = "n";
      options.desc = "Find projects";
    }
    {
      key = "<leader>fa";
      action = "<cmd>Telescope<CR>";
      mode = "n";
      options.desc = "Toggle Telescope";
    }
    {
      key = "<leader>fg";
      action = "<cmd>Telescope git_status<CR>";
      mode = "n";
      options.desc = "Find git status";
    }
    {
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      mode = "n";
      options.desc = "Find buffers";
    }
  ];
}
