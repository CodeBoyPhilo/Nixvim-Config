{
  plugins = {
    tagbar = {
      enable = true;
    };

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>p";
        mode = "n";
        group = "Tagbar";
      }
    ];
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>pp";
      action = "<cmd>TagbarToggle<cr>";
      options = {
        desc = "Toggle Tagbar";
      };
    }
  ];
}
