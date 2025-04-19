{
  plugins.dashboard = {
    enable = true;
    settings = {
      change_to_vcs_root = true;
      config = {
        packages.enable = false;
        footer = [
          ""
          "Welcome back ☕! CodeBoyPhilo 🥱"
          ""
        ];
        mru.limit = 5;
        week_header.enable = true;
        project.enable = true;
        shortcut = [
          {
            action.__raw = "function() Snacks.picker.files() end";
            desc = "󰱼 Files";
            group = "Label";
            key = "f";
          }
          {
            action.__raw = "function() Snacks.picker.recent() end";
            desc = "󱦠 Recent Files";
            group = "Label";
            key = "r";
          }
          {
            action = "quitall!";
            desc = "󰈆 Quit";
            group = "Label";
            key = "q";
          }
        ];
      };
      theme = "hyper";
    };
  };
  highlightOverride = {
    DashboardHeader = {
      fg = "#f9e2af";
      bold = false;
    };
    DashboardFooter = {
      fg = "#f9e2af";
    };

    DashboardProjectTitle = {
      fg = "#f9e2af";
      bold = true;
    };
    DashboardMruTitle = {
      fg = "#f9e2af";
      bold = true;
    };

    Label = {
      fg = "#fab387";
      bold = true;
    };
    DashboardShortcut = {
      fg = "#fab387";
    };

    DashboardFiles = {
      fg = "#f5e0dc";
      bold = false;
    };
  };
  plugins.lualine = {
    settings = {
      options = {
        disabled_filetypes = [
          "dashboard"
        ];
      };
    };
  };
}
