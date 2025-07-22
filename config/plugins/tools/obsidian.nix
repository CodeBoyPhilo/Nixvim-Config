{
  plugins.obsidian = {
    enable = true;
    settings = {
      workspaces = [
        {
          name = "notes";
          path = "~/Documents/notes";
        }
      ];
      templates.subdir = "templates";
			ui.enable = false;
    };
  };
  keymaps = [
    {
      key = "<leader>os";
      action = "<cmd>ObsidianQuickSwitch<CR>";
      mode = "n";
      options.desc = "Quick switch Obsidian notes";
    }
    {
      key = "<leader>ot";
      action = "<cmd>ObsidianTemplate<CR>";
      mode = "n";
      options.desc = "Insert Obsidian template";
    }
    {
      key = "<leader>ow";
      action = "<cmd>ObsidianWorkspace<CR>";
      mode = "n";
      options.desc = "Open Obsidian Workspace";
    }
  ];
}
