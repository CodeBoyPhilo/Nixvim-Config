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

  extraConfigLua = ''
    local dashboard_clock_timer
    local dashboard_clock_group = vim.api.nvim_create_augroup("DashboardLiveClock", { clear = true })

    local function stop_dashboard_clock()
      if dashboard_clock_timer then
        dashboard_clock_timer:stop()
        dashboard_clock_timer:close()
        dashboard_clock_timer = nil
      end
    end

    local function update_dashboard_clock(bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "dashboard" then
        stop_dashboard_clock()
        return
      end

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local now = os.date("%Y-%m-%d %H:%M:%S")

      for i, line in ipairs(lines) do
        if line:find("%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d") then
          local updated = line:gsub("%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d", now, 1)
          if updated ~= line then
            local was_modifiable = vim.bo[bufnr].modifiable
            vim.bo[bufnr].modifiable = true
            vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, { updated })
            vim.bo[bufnr].modifiable = was_modifiable
            vim.bo[bufnr].modified = false
          end
          return
        end
      end
    end

    vim.api.nvim_create_autocmd("User", {
      group = dashboard_clock_group,
      pattern = "DashboardLoaded",
      callback = function(ev)
        stop_dashboard_clock()
        local bufnr = ev.buf ~= 0 and ev.buf or vim.api.nvim_get_current_buf()
        update_dashboard_clock(bufnr)

        dashboard_clock_timer = vim.loop.new_timer()
        dashboard_clock_timer:start(1000, 1000, vim.schedule_wrap(function()
          update_dashboard_clock(bufnr)
        end))
      end,
    })

    vim.api.nvim_create_autocmd({ "BufLeave", "BufWipeout" }, {
      group = dashboard_clock_group,
      callback = function(ev)
        if vim.bo[ev.buf].filetype == "dashboard" then
          stop_dashboard_clock()
        end
      end,
    })
  '';

  # Uncomment for catppuccin
  # highlightOverride = {
  #   DashboardHeader = {
  #     fg = "#f9e2af";
  #     bold = false;
  #   };
  #   DashboardFooter = {
  #     fg = "#f9e2af";
  #   };
  #
  #   DashboardProjectTitle = {
  #     fg = "#f9e2af";
  #     bold = true;
  #   };
  #   DashboardMruTitle = {
  #     fg = "#f9e2af";
  #     bold = true;
  #   };
  #
  #   Label = {
  #     fg = "#fab387";
  #     bold = true;
  #   };
  #   DashboardShortcut = {
  #     fg = "#fab387";
  #   };
  #
  #   DashboardFiles = {
  #     fg = "#f5e0dc";
  #     bold = false;
  #   };
  # };
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
