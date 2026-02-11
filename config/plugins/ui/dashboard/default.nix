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
    local dashboard_preview_host_bufnr
    local dashboard_preview_slot_start
    local dashboard_preview_slot_height
    local dashboard_cursor_hidden = false
    local dashboard_saved_cursor_hl
    local dashboard_saved_lcursor_hl
    local dashboard_saved_cursorim_hl
    local dashboard_saved_termcursor_hl
    local dashboard_saved_termcursornc_hl
    local dashboard_saved_guicursor
    local dashboard_clock_group = vim.api.nvim_create_augroup("DashboardLiveClock", { clear = true })

    local DASHBOARD_PREVIEW_HEIGHT = 20
    local DASHBOARD_PREVIEW_WIDTH = 80
    local DASHBOARD_HEADER_LIFT = 6
    local DASHBOARD_PREVIEW_BG_HL = "DashboardPreviewBackground"
    local DASHBOARD_HIDDEN_CURSOR_HL = "DashboardHiddenCursor"

    local function set_tui_cursor_visible(visible)
      if vim.g.neovide then
        return
      end

      local seq = visible and "\27[?25h" or "\27[?25l"
      pcall(vim.fn.chansend, vim.v.stdout, seq)
      pcall(vim.fn.chansend, vim.v.stderr, seq)
    end

    local function is_dashboard_filetype(filetype)
      return filetype == "dashboard" or filetype == "dashboardpreview"
    end

    local function find_dashboard_window()
      for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(winid) then
          local bufnr = vim.api.nvim_win_get_buf(winid)
          if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == "dashboard" then
            return winid, bufnr
          end
        end
      end
    end

    local function hide_dashboard_cursor()
      if dashboard_cursor_hidden then
        return
      end

      local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
      local normal_float_hl = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
      local bg = normal_hl.bg or normal_float_hl.bg or 0

      if dashboard_saved_cursor_hl == nil then
        dashboard_saved_cursor_hl = vim.api.nvim_get_hl(0, { name = "Cursor", link = true })
      end

      if dashboard_saved_lcursor_hl == nil then
        dashboard_saved_lcursor_hl = vim.api.nvim_get_hl(0, { name = "lCursor", link = true })
      end

      if dashboard_saved_cursorim_hl == nil then
        dashboard_saved_cursorim_hl = vim.api.nvim_get_hl(0, { name = "CursorIM", link = true })
      end

      if dashboard_saved_termcursor_hl == nil then
        dashboard_saved_termcursor_hl = vim.api.nvim_get_hl(0, { name = "TermCursor", link = true })
      end

      if dashboard_saved_termcursornc_hl == nil then
        dashboard_saved_termcursornc_hl = vim.api.nvim_get_hl(0, { name = "TermCursorNC", link = true })
      end

      if dashboard_saved_guicursor == nil then
        dashboard_saved_guicursor = vim.o.guicursor
      end

      vim.api.nvim_set_hl(0, DASHBOARD_PREVIEW_BG_HL, { bg = bg })
      vim.api.nvim_set_hl(0, DASHBOARD_HIDDEN_CURSOR_HL, { fg = bg, bg = bg })
      vim.api.nvim_set_hl(0, "Cursor", { fg = bg, bg = bg })
      vim.api.nvim_set_hl(0, "lCursor", { fg = bg, bg = bg })
      vim.api.nvim_set_hl(0, "CursorIM", { fg = bg, bg = bg })
      vim.api.nvim_set_hl(0, "TermCursor", { fg = bg, bg = bg })
      vim.api.nvim_set_hl(0, "TermCursorNC", { fg = bg, bg = bg })

      vim.o.guicursor = table.concat({
        "n-v-c-sm:block-" .. DASHBOARD_HIDDEN_CURSOR_HL,
        "i-ci-ve:ver25-" .. DASHBOARD_HIDDEN_CURSOR_HL,
        "r-cr-o:hor20-" .. DASHBOARD_HIDDEN_CURSOR_HL,
        "t:block-" .. DASHBOARD_HIDDEN_CURSOR_HL,
      }, ",")

      set_tui_cursor_visible(false)

      dashboard_cursor_hidden = true
    end

    local function show_dashboard_cursor()
      if not dashboard_cursor_hidden then
        return
      end

      if dashboard_saved_cursor_hl ~= nil then
        vim.api.nvim_set_hl(0, "Cursor", dashboard_saved_cursor_hl)
      end

      if dashboard_saved_lcursor_hl ~= nil then
        vim.api.nvim_set_hl(0, "lCursor", dashboard_saved_lcursor_hl)
      end

      if dashboard_saved_cursorim_hl ~= nil then
        vim.api.nvim_set_hl(0, "CursorIM", dashboard_saved_cursorim_hl)
      end

      if dashboard_saved_termcursor_hl ~= nil then
        vim.api.nvim_set_hl(0, "TermCursor", dashboard_saved_termcursor_hl)
      end

      if dashboard_saved_termcursornc_hl ~= nil then
        vim.api.nvim_set_hl(0, "TermCursorNC", dashboard_saved_termcursornc_hl)
      end

      if dashboard_saved_guicursor ~= nil then
        vim.o.guicursor = dashboard_saved_guicursor
      end

      set_tui_cursor_visible(true)

      dashboard_cursor_hidden = false
    end

    local function refresh_dashboard_cursor()
      local current_buf = vim.api.nvim_get_current_buf()
      if not vim.api.nvim_buf_is_valid(current_buf) then
        show_dashboard_cursor()
        return
      end

      if is_dashboard_filetype(vim.bo[current_buf].filetype) then
        hide_dashboard_cursor()
      else
        show_dashboard_cursor()
      end
    end

    local function stop_dashboard_clock()
      if dashboard_clock_timer then
        dashboard_clock_timer:stop()
        dashboard_clock_timer:close()
        dashboard_clock_timer = nil
      end
    end

    local function remove_preview_slot()
      if not dashboard_preview_host_bufnr or not vim.api.nvim_buf_is_valid(dashboard_preview_host_bufnr) then
        dashboard_preview_host_bufnr = nil
        dashboard_preview_slot_start = nil
        dashboard_preview_slot_height = nil
        return
      end

      if not dashboard_preview_slot_start or not dashboard_preview_slot_height or dashboard_preview_slot_height <= 0 then
        dashboard_preview_host_bufnr = nil
        dashboard_preview_slot_start = nil
        dashboard_preview_slot_height = nil
        return
      end

      local line_count = vim.api.nvim_buf_line_count(dashboard_preview_host_bufnr)
      if dashboard_preview_slot_start < 0 or dashboard_preview_slot_start >= line_count then
        dashboard_preview_host_bufnr = nil
        dashboard_preview_slot_start = nil
        dashboard_preview_slot_height = nil
        return
      end

      local slot_end = math.min(dashboard_preview_slot_start + dashboard_preview_slot_height, line_count)
      if slot_end <= dashboard_preview_slot_start then
        dashboard_preview_host_bufnr = nil
        dashboard_preview_slot_start = nil
        dashboard_preview_slot_height = nil
        return
      end

      local slot_lines = vim.api.nvim_buf_get_lines(
        dashboard_preview_host_bufnr,
        dashboard_preview_slot_start,
        slot_end,
        false
      )

      local all_blank = true
      for _, line in ipairs(slot_lines) do
        if line ~= "" then
          all_blank = false
          break
        end
      end

      if all_blank then
        local was_modifiable = vim.bo[dashboard_preview_host_bufnr].modifiable
        vim.bo[dashboard_preview_host_bufnr].modifiable = true
        vim.api.nvim_buf_set_lines(
          dashboard_preview_host_bufnr,
          dashboard_preview_slot_start,
          slot_end,
          false,
          {}
        )
        vim.bo[dashboard_preview_host_bufnr].modifiable = was_modifiable
        vim.bo[dashboard_preview_host_bufnr].modified = false
      end

      dashboard_preview_host_bufnr = nil
      dashboard_preview_slot_start = nil
      dashboard_preview_slot_height = nil
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

      remove_preview_slot()
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

      dashboard_preview_host_bufnr = bufnr
      dashboard_preview_slot_start = insert_at
      dashboard_preview_slot_height = height
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

      stop_dashboard_preview()

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
        stop_dashboard_preview()
        return
      end

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

      if vim.g.neovide then
        local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
        local bg = normal_hl.bg

        if bg then
          vim.api.nvim_set_hl(0, DASHBOARD_PREVIEW_BG_HL, { bg = bg })
          vim.wo[dashboard_preview_winid].winhighlight = table.concat({
            "Normal:" .. DASHBOARD_PREVIEW_BG_HL,
            "NormalNC:" .. DASHBOARD_PREVIEW_BG_HL,
            "NormalFloat:" .. DASHBOARD_PREVIEW_BG_HL,
            "Terminal:" .. DASHBOARD_PREVIEW_BG_HL,
          }, ",")
        end
      end

      vim.api.nvim_buf_call(dashboard_preview_bufnr, function()
        vim.fn.termopen("asciiquarium -t")
      end)
    end

    local function preview_running_for(bufnr)
      return dashboard_preview_host_bufnr == bufnr
        and dashboard_preview_winid
        and vim.api.nvim_win_is_valid(dashboard_preview_winid)
        and dashboard_preview_bufnr
        and vim.api.nvim_buf_is_valid(dashboard_preview_bufnr)
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

    local function refresh_dashboard_state()
      local _, dashboard_bufnr = find_dashboard_window()
      if not dashboard_bufnr then
        stop_dashboard_clock()
        stop_dashboard_preview()
        return
      end

      update_dashboard_clock(dashboard_bufnr)

      if not preview_running_for(dashboard_bufnr) then
        start_dashboard_preview(dashboard_bufnr)
      end

      if dashboard_clock_timer then
        return
      end

      dashboard_clock_timer = vim.loop.new_timer()
      dashboard_clock_timer:start(1000, 1000, vim.schedule_wrap(function()
        local _, visible_dashboard_bufnr = find_dashboard_window()
        if not visible_dashboard_bufnr then
          stop_dashboard_clock()
          stop_dashboard_preview()
          return
        end

        update_dashboard_clock(visible_dashboard_bufnr)
        if not preview_running_for(visible_dashboard_bufnr) then
          start_dashboard_preview(visible_dashboard_bufnr)
        end
      end))
    end

    vim.api.nvim_create_autocmd("User", {
      group = dashboard_clock_group,
      pattern = "DashboardLoaded",
      callback = function(ev)
        stop_dashboard_clock()
        stop_dashboard_preview()
        local bufnr = ev.buf ~= 0 and ev.buf or vim.api.nvim_get_current_buf()

        local dashboard_winid = vim.fn.bufwinid(bufnr)
        if dashboard_winid ~= -1 then
          vim.wo[dashboard_winid].cursorline = false
        end

        refresh_dashboard_cursor()

        lift_dashboard_header(bufnr, DASHBOARD_HEADER_LIFT)
        refresh_dashboard_state()
      end,
    })

    vim.api.nvim_create_autocmd({
      "BufEnter",
      "BufWinEnter",
      "BufHidden",
      "BufWipeout",
      "WinEnter",
      "WinClosed",
      "TabEnter",
      "VimResized",
    }, {
      group = dashboard_clock_group,
      callback = function()
        vim.schedule(function()
          refresh_dashboard_state()
        end)
      end,
    })

    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermEnter", "TermLeave", "ModeChanged" }, {
      group = dashboard_clock_group,
      callback = function()
        refresh_dashboard_cursor()
      end,
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = dashboard_clock_group,
      callback = function()
        show_dashboard_cursor()
        dashboard_saved_cursor_hl = nil
        dashboard_saved_lcursor_hl = nil
        dashboard_saved_cursorim_hl = nil
        dashboard_saved_termcursor_hl = nil
        dashboard_saved_termcursornc_hl = nil
        dashboard_saved_guicursor = nil
        refresh_dashboard_cursor()
      end,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = dashboard_clock_group,
      callback = function()
        stop_dashboard_clock()
        stop_dashboard_preview()
        show_dashboard_cursor()
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
