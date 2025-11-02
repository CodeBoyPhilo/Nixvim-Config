{
  plugins.typst-preview = {
    enable = true;
    # dependencies_bin = {
    #   tinymist = "tinymist";
    # };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>pd";
      action = "<cmd>TypstPreview document<cr>";
      options = {
        desc = "Preview Typst Document";
      };
    }
    {
      mode = "n";
      key = "<leader>ps";
      action = "<cmd>TypstPreview slide<cr>";
      options = {
        desc = "Preview Typst Slides";
      };
    }
    {
      mode = "n";
      key = "<leader>pt";
      action = "<cmd>TypstPreviewToggle<cr>";
      options = {
        desc = "Toggle Typst Preview";
      };
    }
  ];
}
