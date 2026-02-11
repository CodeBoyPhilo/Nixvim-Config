{
  plugins.dashboard = {
    enable = true;
    settings = {
      change_to_vcs_root = true;
      config = {
        disable_move = true;
        packages.enable = false;
        footer = [
          ""
          "Welcome back ☕! CodeBoyPhilo 🥱"
          ""
        ];
        mru.enable = false;
        week_header.enable = true;
        project.enable = false;
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
    };
  };

  extraConfigLua = ''
    local dashboard_clock_timer
    local dashboard_preview_bufnr
    local dashboard_preview_winid
    local dashboard_clock_group = vim.api.nvim_create_augroup("DashboardLiveClock", { clear = true })

    local DASHBOARD_PREVIEW_HEIGHT = 20
    local DASHBOARD_PREVIEW_WIDTH = 80
    local DASHBOARD_HEADER_LIFT = 6

    local function stop_dashboard_clock()
      if dashboard_clock_timer then
        dashboard_clock_timer:stop()
        dashboard_clock_timer:close()
        dashboard_clock_timer = nil
      end
    end

    local function stop_dashboard_preview()
      if dashboard_preview_winid and vim.api.nvim_win_is_valid(dashboard_preview_winid) then
        vim.api.nvim_win_close(dashboard_preview_winid, true)
      end
      dashboard_preview_winid = nil

      if dashboard_preview_bufnr and vim.api.nvim_buf_is_valid(dashboard_preview_bufnr) then
        vim.api.nvim_buf_delete(dashboard_preview_bufnr, { force = true })
      end
      dashboard_preview_bufnr = nil
    end

    local function find_dashboard_time_line(lines)
      for i, line in ipairs(lines) do
        if line:find("%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d") then
          return i
        end
      end
    end

    local function insert_preview_slot(bufnr, insert_at, height)
      local spacer = {}
      for _ = 1, height do
        table.insert(spacer, "")
      end

      local was_modifiable = vim.bo[bufnr].modifiable
      vim.bo[bufnr].modifiable = true
      vim.api.nvim_buf_set_lines(bufnr, insert_at, insert_at, false, spacer)
      vim.bo[bufnr].modifiable = was_modifiable
      vim.bo[bufnr].modified = false
    end

    local function lift_dashboard_header(bufnr, amount)
      if amount <= 0 then
        return
      end

      local top_lines = vim.api.nvim_buf_get_lines(bufnr, 0, amount, false)
      local removable = 0
      for _, line in ipairs(top_lines) do
        if line == "" then
          removable = removable + 1
        else
          break
        end
      end

      if removable == 0 then
        return
      end

      local was_modifiable = vim.bo[bufnr].modifiable
      vim.bo[bufnr].modifiable = true
      vim.api.nvim_buf_set_lines(bufnr, 0, removable, false, {})
      vim.bo[bufnr].modifiable = was_modifiable
      vim.bo[bufnr].modified = false
    end

    local function start_dashboard_preview(bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "dashboard" then
        return
      end

      local winid = vim.fn.bufwinid(bufnr)
      if winid == -1 then
        return
      end

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local time_line = find_dashboard_time_line(lines)
      if not time_line then
        return
      end

      local win_height = vim.api.nvim_win_get_height(winid)
      local line_count = vim.api.nvim_buf_line_count(bufnr)
      local available_extra_lines = win_height - line_count - 1
      local preview_height = math.min(DASHBOARD_PREVIEW_HEIGHT, math.max(0, available_extra_lines))
      if preview_height == 0 then
        return
      end

      insert_preview_slot(bufnr, time_line, preview_height)

      local preview_width = math.min(
        DASHBOARD_PREVIEW_WIDTH,
        math.max(40, vim.api.nvim_win_get_width(winid) - 4)
      )
      local pos = vim.fn.screenpos(winid, time_line + 1, 1)
      if not pos or pos.row == 0 then
        return
      end

      stop_dashboard_preview()

      dashboard_preview_bufnr = vim.api.nvim_create_buf(false, true)
      vim.bo[dashboard_preview_bufnr].bufhidden = "wipe"
      vim.bo[dashboard_preview_bufnr].filetype = "dashboardpreview"

      dashboard_preview_winid = vim.api.nvim_open_win(dashboard_preview_bufnr, false, {
        relative = "editor",
        row = pos.row - 1,
        col = math.floor((vim.o.columns - preview_width) / 2),
        width = preview_width,
        height = preview_height,
        style = "minimal",
        noautocmd = true,
        focusable = false,
      })

      vim.api.nvim_buf_call(dashboard_preview_bufnr, function()
        vim.fn.termopen("asciiquarium -t")
      end)
    end

    local function update_dashboard_clock(bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "dashboard" then
        stop_dashboard_clock()
        stop_dashboard_preview()
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
        stop_dashboard_preview()
        local bufnr = ev.buf ~= 0 and ev.buf or vim.api.nvim_get_current_buf()
        lift_dashboard_header(bufnr, DASHBOARD_HEADER_LIFT)
        update_dashboard_clock(bufnr)
        start_dashboard_preview(bufnr)

        dashboard_clock_timer = vim.loop.new_timer()
        dashboard_clock_timer:start(1000, 1000, vim.schedule_wrap(function()
          update_dashboard_clock(bufnr)
        end))
      end,
    })

    vim.api.nvim_create_autocmd({ "BufLeave", "BufWipeout" }, {
      group = dashboard_clock_group,
      callback = function(ev)
        if vim.bo[ev.buf].filetype == "dashboard" or vim.bo[ev.buf].filetype == "dashboardpreview" then
          stop_dashboard_clock()
          stop_dashboard_preview()
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
