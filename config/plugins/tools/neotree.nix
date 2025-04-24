{
  plugins.neo-tree = {
    enable = true;
    enableDiagnostics = true;
    enableGitStatus = true;
    enableModifiedMarkers = true;
    enableRefreshOnWrite = true;
    closeIfLastWindow = true;
    popupBorderStyle = "rounded"; # Type: null or one of “NC”, “double”, “none”, “rounded”, “shadow”, “single”, “solid” or raw lua code
    filesystem = {
      filteredItems = {
        visible = true;
        neverShow = [
          ".git"
          ".DS_Store"
        ];
      };
    };
    buffers = {
      bindToCwd = false;
      followCurrentFile = {
        enabled = true;
      };
    };
    window = {
      width = 40;
      height = 15;
      autoExpandWidth = false;
      mappings = {
        "<C-t>" = "open_tabnew";
        "<C-v>" = "open_vsplit";
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
