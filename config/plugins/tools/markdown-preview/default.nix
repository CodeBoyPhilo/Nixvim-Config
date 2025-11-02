{
  plugins.markdown-preview = {
    enable = true;
  };
	keymaps = [
	    {
      mode = [
        "n"
      ];
      key = "<leader>pm";
      action = "<cmd>MarkdownPreviewToggle<cr>";
      options = {
        desc = "Toggle Markdown Preview";
      };
    }

	];
}
