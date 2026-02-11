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
        bind_to_cwd = true;
        follow_current_file = {
          enabled = true;
          leave_dirs_open = true;
        };
        filtered_items = {
          visible = true;
          never_show = [
            ".git"
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
        auto_expand_width = true;
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
      # action = ":Neotree filesystem float reveal_force_cwd<cr>";
			action = ":Neotree float toggle reveal_force_cwd<cr>";
      options = {
        silent = true;
        desc = "Explorer NeoTree";
      };
    }
    {
      mode = "n";
      key = "<leader>eb";
      action = ":Neotree buffers float<CR>";
      options = {
        silent = true;
        desc = "Buffer explorer";
      };
    }
    {
      mode = "n";
      key = "<leader>eg";
      action = ":Neotree git_status float<CR>";
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
