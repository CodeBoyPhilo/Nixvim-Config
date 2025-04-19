{
  plugins.snacks = {
    settings = {
      dashboard = {
        enabled = false;
        preset = {
          keys = [
            {
              icon = "󰱼 ";
              key = "f";
              desc = "Find File";
              action = ":lua Snacks.dashboard.pick('files')";
              hidden = false;
            }
            {
              icon = " ";
              key = "w";
              desc = "Find word";
              action = ":lua Snacks.dashboard.pick('live_grep')";
              hidden = false;
            }
            {
              icon = " ";
              key = "c";
              desc = "Config";
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})";
              hidden = true;
            }
            {
              icon = " ";
              key = "q";
              desc = "Quit";
              action = ":qa";
              hidden = false;
            }
          ];
        };
        sections = [
          {
            section = "keys";
            padding = 1;
          }
          {
            icon = " ";
            title = "Recent Files";
            section = "recent_files";
            indent = 2;
            padding = 1;
          }
          {
            icon = " ";
            title = "Projects";
            section = "projects";
            indent = 2;
            padding = 1;
          }
        ];
      };
    };
  };
}
