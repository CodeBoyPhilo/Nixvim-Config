{
  plugins.neo-tree = {
    enable = true;
    settings = {

      enable_diagnostics = true;
      enable_gitStatus = true;
      enable_modified_markers = true;
      enable_refresh_on_write = true;
      close_if_last_window = true;
      popup_border_style = "rounded"; # Type: null or one of “NC”, “double”, “none”, “rounded”, “shadow”, “single”, “solid” or raw lua code
      filesystem = {
        filtered_items = {
          visible = true;
          never_show = [
            ".git"
            ".gitignore"
            ".DS_Store"
            "__pycache__"
            ".ipynb_checkpoints"
            ".python-version"
            "uv.lock"
          ];
        };
      };
      buffers = {
        bind_to_cwd = true;
        follow_current_file = {
          enabled = true;
        };
      };
      window = {
        width = 40;
        height = 15;
        auto_expand_width = false;
        mappings = {
          "<C-t>" = "open_tabnew";
          "<C-v>" = "open_vsplit";
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ee";
      action = ":Neotree toggle reveal_force_cwd<cr>";
      options = {
        silent = true;
        desc = "Explorer NeoTree (root dir)";
      };
    }
    {
      mode = "n";
      key = "<leader>eE";
      action = "<cmd>Neotree toggle<CR>";
      options = {
        silent = true;
        desc = "Explorer NeoTree (cwd)";
      };
    }
    {
      mode = "n";
      key = "<leader>eb";
      action = ":Neotree buffers<CR>";
      options = {
        silent = true;
        desc = "Buffer explorer";
      };
    }
    {
      mode = "n";
      key = "<leader>eg";
      action = ":Neotree git_status<CR>";
      options = {
        silent = true;
        desc = "Git explorer";
      };
    }
  ];

  plugins.lualine = {
    settings = {
      options = {
        disabled_filetypes = [
          "neo-tree"
        ];
      };
    };
  };

}
