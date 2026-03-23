{
  keymaps = [
    {
      mode = "n";
      key = "<leader><Tab>";
      action.__raw = ''
        function()
          _G.OpenCodeTabSwitcher.open()
        end
      '';
      options.desc = "Open tab switcher";
    }
  ];

  extraConfigLua = ''
    local tab_switcher = {
      buf = nil,
      win = nil,
      tabs = {},
      selected = 1,
      origin = nil,
      last_focused_tab = nil,
      current_focused_tab = vim.api.nvim_get_current_tabpage(),
    }

    local ns = vim.api.nvim_create_namespace("opencode-tab-switcher")
    local augroup = vim.api.nvim_create_augroup("OpenCodeTabSwitcher", { clear = true })
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")
    local MAX_BODY_WIDTH = 72

    local function valid_buf(buf)
      return buf and vim.api.nvim_buf_is_valid(buf)
    end

    local function valid_win(win)
      return win and vim.api.nvim_win_is_valid(win)
    end

    local function valid_tab(tab)
      return tab and vim.api.nvim_tabpage_is_valid(tab)
    end

    local function truncate_label(text, limit)
      if vim.fn.strdisplaywidth(text) <= limit then
        return text
      end

      return vim.fn.strcharpart(text, 0, math.max(1, limit - 3)) .. "..."
    end

    local function apply_highlights()
      local normal = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
      local title = vim.api.nvim_get_hl(0, { name = "FloatTitle", link = false })
      local border = vim.api.nvim_get_hl(0, { name = "FloatBorder", link = false })
      local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
      local visual = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
      local directory = vim.api.nvim_get_hl(0, { name = "Directory", link = false })

      vim.api.nvim_set_hl(0, "OpenCodeTabSwitcherBorder", {
        fg = border.fg or title.fg or normal.fg,
        bg = normal.bg,
      })

      vim.api.nvim_set_hl(0, "OpenCodeTabSwitcherTitle", {
        fg = title.fg or directory.fg or normal.fg,
        bg = normal.bg,
        bold = true,
      })

      vim.api.nvim_set_hl(0, "OpenCodeTabSwitcherSelection", {
        fg = visual.fg or normal.fg,
        bg = visual.bg or normal.bg,
        bold = true,
      })

      vim.api.nvim_set_hl(0, "OpenCodeTabSwitcherCurrent", {
        fg = directory.fg or title.fg or normal.fg,
        bg = normal.bg,
        bold = true,
      })

      vim.api.nvim_set_hl(0, "OpenCodeTabSwitcherIndex", {
        fg = comment.fg or normal.fg,
        bg = normal.bg,
      })

      vim.api.nvim_set_hl(0, "OpenCodeTabSwitcherDim", {
        fg = comment.fg or normal.fg,
        bg = normal.bg,
      })
    end

    local function tab_label(tabpage)
      local win = vim.api.nvim_tabpage_get_win(tabpage)
      local buf = vim.api.nvim_win_get_buf(win)
      local name = vim.api.nvim_buf_get_name(buf)
      local filename = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"
      local directory = ""
      local icon = ""
      local icon_hl = nil

      if name ~= "" then
        directory = vim.fn.fnamemodify(name, ":~:.:h")
        if directory == "." then
          directory = ""
        end

        if has_devicons then
          local matched_icon, matched_hl = devicons.get_icon(filename, vim.fn.fnamemodify(name, ":e"), { default = true })
          if matched_icon and matched_icon ~= "" then
            icon = matched_icon
            icon_hl = matched_hl
          end
        end
      end

      return {
        filename = filename,
        directory = directory,
        modified = vim.bo[buf].modified,
        icon = icon,
        icon_hl = icon_hl,
      }
    end

    local function format_entry(index, entry)
      local current_mark = entry.tab == tab_switcher.origin and "*" or " "
      local prefix = string.format(" %s %2d  ", current_mark, index)
      local line = prefix
      local columns = {
        index_start = 1,
        index_end = 5,
      }

      columns.icon_start = #line
      line = line .. entry.icon
      columns.icon_end = #line

      line = line .. " "
      line = line .. entry.filename

      if entry.directory ~= "" then
        local available = MAX_BODY_WIDTH
          - vim.fn.strdisplaywidth(entry.icon .. " " .. entry.filename)
          - (entry.modified and vim.fn.strdisplaywidth("   [+]") or 0)
          - vim.fn.strdisplaywidth("   ")

        if available > 0 then
          local directory = truncate_label(entry.directory, available)
          columns.directory_start = #line + #"   "
          line = line .. "   " .. directory
          columns.directory_end = #line
        end
      end

      if entry.modified then
        columns.modified_start = #line + #"   "
        line = line .. "   [+]"
        columns.modified_end = #line
      end

      return line, columns
    end

    local function remember_tab_focus()
      local current = vim.api.nvim_get_current_tabpage()
      if current ~= tab_switcher.current_focused_tab then
        if valid_tab(tab_switcher.current_focused_tab) then
          tab_switcher.last_focused_tab = tab_switcher.current_focused_tab
        end

        tab_switcher.current_focused_tab = current
      end
    end

    local function clear_state()
      tab_switcher.buf = nil
      tab_switcher.win = nil
      tab_switcher.tabs = {}
      tab_switcher.selected = 1
      tab_switcher.origin = nil
    end

    local function set_selection(index)
      local count = #tab_switcher.tabs
      if count == 0 then
        return
      end

      tab_switcher.selected = ((index - 1) % count) + 1

      if valid_win(tab_switcher.win) then
        vim.api.nvim_win_set_cursor(tab_switcher.win, { tab_switcher.selected, 0 })
      end
    end

    local function selection_from_cursor()
      if not valid_win(tab_switcher.win) then
        return tab_switcher.selected
      end

      local line = vim.api.nvim_win_get_cursor(tab_switcher.win)[1]
      if #tab_switcher.tabs == 0 then
        return 1
      end

      return math.max(1, math.min(line, #tab_switcher.tabs))
    end

    local function render()
      if not valid_buf(tab_switcher.buf) then
        return
      end

      local lines = {}
      local metadata = {}
      for index, entry in ipairs(tab_switcher.tabs) do
        lines[index], metadata[index] = format_entry(index, entry)
      end

      vim.bo[tab_switcher.buf].modifiable = true
      vim.api.nvim_buf_set_lines(tab_switcher.buf, 0, -1, false, lines)
      vim.api.nvim_buf_clear_namespace(tab_switcher.buf, ns, 0, -1)

      for index, entry in ipairs(tab_switcher.tabs) do
        local columns = metadata[index]

        vim.api.nvim_buf_add_highlight(
          tab_switcher.buf,
          ns,
          "OpenCodeTabSwitcherIndex",
          index - 1,
          columns.index_start,
          columns.index_end
        )

        if entry.icon_hl then
          vim.api.nvim_buf_add_highlight(
            tab_switcher.buf,
            ns,
            entry.icon_hl,
            index - 1,
            columns.icon_start,
            columns.icon_end
          )
        end

        if columns.directory_start and columns.directory_end then
          vim.api.nvim_buf_add_highlight(
            tab_switcher.buf,
            ns,
            "OpenCodeTabSwitcherDim",
            index - 1,
            columns.directory_start,
            columns.directory_end
          )
        end

        if columns.modified_start and columns.modified_end then
          vim.api.nvim_buf_add_highlight(
            tab_switcher.buf,
            ns,
            "OpenCodeTabSwitcherCurrent",
            index - 1,
            columns.modified_start,
            columns.modified_end
          )
        end

        if entry.tab == tab_switcher.origin and index ~= tab_switcher.selected then
          vim.api.nvim_buf_add_highlight(tab_switcher.buf, ns, "OpenCodeTabSwitcherCurrent", index - 1, 0, -1)
        end
      end

      vim.bo[tab_switcher.buf].modifiable = false
      set_selection(tab_switcher.selected)
    end

    function tab_switcher.close()
      local win = tab_switcher.win
      local buf = tab_switcher.buf

      clear_state()

      if valid_win(win) then
        pcall(vim.api.nvim_win_close, win, true)
      end

      if valid_buf(buf) then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end

    function tab_switcher.step(delta)
      if #tab_switcher.tabs == 0 then
        return
      end

      set_selection(tab_switcher.selected + delta)
    end

    function tab_switcher.confirm()
      tab_switcher.selected = selection_from_cursor()

      local entry = tab_switcher.tabs[tab_switcher.selected]
      if not entry then
        tab_switcher.close()
        return
      end

      local target_tab = entry.tab
      tab_switcher.close()

      vim.schedule(function()
        if valid_tab(target_tab) then
          vim.api.nvim_set_current_tabpage(target_tab)
        end
      end)
    end

    function tab_switcher.jump_to_previous_focus()
      local target_tab = tab_switcher.last_focused_tab
      if not valid_tab(target_tab) then
        return
      end

      if target_tab == vim.api.nvim_get_current_tabpage() then
        return
      end

      vim.api.nvim_set_current_tabpage(target_tab)
    end

    function tab_switcher.open()
      if valid_win(tab_switcher.win) or valid_buf(tab_switcher.buf) then
        tab_switcher.close()
      end

      local current_tab = vim.api.nvim_get_current_tabpage()
      local tabs = {}
      local selected = 1

      for index, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
        local label = tab_label(tabpage)
        tabs[index] = {
          tab = tabpage,
          filename = label.filename,
          directory = label.directory,
          modified = label.modified,
          icon = label.icon,
          icon_hl = label.icon_hl,
        }

        if tabpage == current_tab then
          selected = index
        end
      end

      if #tabs == 0 then
        return
      end

      local width = 0
      for index, entry in ipairs(tabs) do
        local line = format_entry(index, entry)
        width = math.max(width, vim.fn.strdisplaywidth(line))
      end

      width = math.max(36, math.min(width + 4, math.floor(vim.o.columns * 0.7)))

      local height = math.min(#tabs, math.max(1, vim.o.lines - 6))
      local row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1)
      local col = math.max(0, math.floor((vim.o.columns - width) / 2))

      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].buftype = "nofile"
      vim.bo[buf].bufhidden = "wipe"
      vim.bo[buf].swapfile = false
      vim.bo[buf].modifiable = false
      vim.bo[buf].filetype = "tabswitcher"

      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        row = row,
        col = col,
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
        title = " Tab Switcher ",
        title_pos = "center",
        zindex = 60,
      })

      vim.wo[win].cursorline = true
      vim.wo[win].number = false
      vim.wo[win].relativenumber = false
      vim.wo[win].signcolumn = "no"
      vim.wo[win].foldcolumn = "0"
      vim.wo[win].spell = false
      vim.wo[win].wrap = false
      vim.wo[win].winblend = 6
      vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:OpenCodeTabSwitcherBorder,FloatTitle:OpenCodeTabSwitcherTitle,CursorLine:OpenCodeTabSwitcherSelection"

      tab_switcher.buf = buf
      tab_switcher.win = win
      tab_switcher.tabs = tabs
      tab_switcher.selected = selected
      tab_switcher.origin = current_tab

      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, {
          buffer = buf,
          nowait = true,
          silent = true,
          desc = desc,
        })
      end

      map("j", function()
        tab_switcher.step(1)
      end, "Next tab")

      map("k", function()
        tab_switcher.step(-1)
      end, "Previous tab")

      map("<CR>", function()
        tab_switcher.confirm()
      end, "Confirm tab")

      map("<Esc>", function()
        tab_switcher.close()
      end, "Close tab switcher")

      map("q", function()
        tab_switcher.close()
      end, "Close tab switcher")

      render()
    end

    apply_highlights()

    vim.api.nvim_create_autocmd({ "TabEnter", "VimEnter" }, {
      group = augroup,
      callback = function()
        remember_tab_focus()
      end,
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = augroup,
      callback = function()
        apply_highlights()
      end,
    })

    _G.OpenCodeTabSwitcher = tab_switcher
  '';
}
