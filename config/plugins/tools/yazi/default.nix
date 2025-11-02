{
  plugins.yazi = {
    enable = true;
    settings = {
      enable_mouse_support = true;
    };
  };


  keymaps = [
    {
      key = "<leader>y";
      action = "<cmd>Yazi<CR>";
      mode = "n";
      options.desc = "Open Yazi at the current file";
    }
  ];
}
