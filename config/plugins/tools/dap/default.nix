{ pkgs, ... }:
let
  debugpyPython = pkgs.python3.withPackages (ps: [ ps.debugpy ]);
in
{
  extraPackages = [ debugpyPython ];

  plugins = {
    dap-virtual-text = {
      enable = true;
      settings = {
        enabled = true;
        enable_commands = true;
        commented = false;
        virt_text_pos = "inline";
        display_callback.__raw = ''
          function(variable, buf, stackframe, node, options)
            local max_len = vim.g.dap_virtual_text_max_len or 80
            local value = tostring(variable.value or ""):gsub("%s+", " ")

            if max_len > 3 and #value > max_len then
              local head_len = math.floor((max_len - 3) / 2)
              local tail_len = max_len - 3 - head_len
              value = value:sub(1, head_len) .. "..." .. value:sub(#value - tail_len + 1)
            end

            if options.virt_text_pos == "inline" then
              return " = " .. value
            end
            return variable.name .. " = " .. value
          end
        '';
      };
    }; 

    dap-python = {
      enable = true;
    };

    dap = {
      enable = true;
      signs = {
        dapBreakpoint = {
          text = " ";
          texthl = "DiagnosticSignError";
        };
        dapBreakpointCondition = {
          text = " ";
          texthl = "DiagnosticInfo";
        };
        dapBreakpointRejected = {
          text = " ";
          texthl = "DiagnosticError";
        };
        dapLogPoint = {
          text = " ";
          texthl = "DiagnosticInfo";
        };
        dapStopped = {
          text = "󰁕 ";
          texthl = "DiagnosticWarn";
          linehl = "DapStoppedLine";
          numhl = "DapStoppedLine";
        };
      };
    };

    dap-ui = {
      enable = true;
      settings = {
        layouts = [
          {
            elements = [ "repl" ];
            size = 10;
            position = "bottom";
          }
        ];
        render = {
          max_type_length = 32;
          max_value_lines = 5;
        };
      };
    };
  };

  keymaps = [
    # Toggle breakpoint
    {
      mode = "n";
      key = "<leader>db";
      action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
      options = {
        silent = true;
        desc = "Toggle breakpoint";
      };
    }
    # Continue / Start
    {
      mode = "n";
      key = "<leader>dc";
      action = "<cmd>lua require('dap').continue()<CR>";
      options = {
        silent = true;
        desc = "Start/Continue debugging";
      };
    }
    # Step Over
    {
      mode = "n";
      key = "<leader>do";
      action = "<cmd>lua require('dap').step_over()<CR>";
      options = {
        silent = true;
        desc = "Step over";
      };
    }
    # Step Into
    {
      mode = "n";
      key = "<leader>di";
      action = "<cmd>lua require('dap').step_into()<CR>";
      options = {
        silent = true;
        desc = "Step into";
      };
    }
    # Step Out
    {
      mode = "n";
      key = "<leader>dO";
      action = "<cmd>lua require('dap').step_out()<CR>";
      options = {
        silent = true;
        desc = "Step out";
      };
    }
    # Terminate debugging
    {
      mode = "n";
      key = "<leader>dq";
      action = "<cmd>lua require('dap').terminate()<CR>";
      options = {
        silent = true;
        desc = "Terminate debugging";
      };
    }
    # Toggle DAP UI
    {
      mode = "n";
      key = "<leader>du";
      action = "<cmd>DapUIToggle<CR>";
      options = {
        silent = true;
        desc = "Toggle debug UI";
      };
    }
    # Toggle DAP UI side panels
    {
      mode = "n";
      key = "<leader>dS";
      action = "<cmd>DapUIScopesToggle<CR>";
      options = {
        silent = true;
        desc = "Toggle DAP scopes";
      };
    }
    {
      mode = "n";
      key = "<leader>dT";
      action = "<cmd>DapUIStacksToggle<CR>";
      options = {
        silent = true;
        desc = "Toggle DAP stacks";
      };
    }
    {
      mode = "n";
      key = "<leader>dW";
      action = "<cmd>DapUIWatchesToggle<CR>";
      options = {
        silent = true;
        desc = "Toggle DAP watches";
      };
    }
    {
      mode = "n";
      key = "<leader>dB";
      action = "<cmd>DapUIBreakpointsToggle<CR>";
      options = {
        silent = true;
        desc = "Toggle DAP breakpoints panel";
      };
    }
    {
      mode = "n";
      key = "<leader>dX";
      action = "<cmd>DapUISideClose<CR>";
      options = {
        silent = true;
        desc = "Close DAP side panels";
      };
    }
    # Toggle DAP virtual text
    {
      mode = "n";
      key = "<leader>dV";
      action = "<cmd>DapGhostTextToggle<CR>";
      options = {
        silent = true;
        desc = "Toggle DAP virtual text";
      };
    }
    {
      mode = "n";
      key = "<leader>dv";
      action = "<cmd>DapGhostTextToggle<CR>";
      options = {
        silent = true;
        desc = "Toggle DAP virtual text";
      };
    }
  ];

  extraConfigLua = ''
    local dap = require("dap")
    local dapui = require("dapui")

    local history_file = vim.fn.stdpath("data") .. "/dap-python-command-history.txt"
    local debug_log = vim.fn.stdpath("state") .. "/dap-python-command.log"
    local last_python_file = nil

    local function is_real_file(path)
      return path and path ~= "" and vim.fn.filereadable(path) == 1
    end

    local function current_file()
      local path = vim.api.nvim_buf_get_name(0)
      if vim.bo.buftype == "" and is_real_file(path) then
        return path
      end
      if is_real_file(last_python_file) then
        return last_python_file
      end
      return nil
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = "*.py",
      callback = function(args)
        local path = vim.api.nvim_buf_get_name(args.buf)
        if is_real_file(path) then
          last_python_file = path
        end
      end,
    })

    local function project_root(path)
      local file = path or current_file()
      local start = file and vim.fs.dirname(file) or vim.fn.getcwd()
      return vim.fs.root(start, { ".venv", "pyproject.toml", "uv.lock", ".git" }) or start
    end

    local function first_executable(paths)
      for _, path in ipairs(paths) do
        if path and path ~= "" and vim.fn.executable(path) == 1 then
          return path
        end
      end
      return nil
    end

    local function project_python(root)
      root = root or project_root()
      local python = first_executable({
        root .. "/.venv/bin/python",
        vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or nil,
        vim.env.CONDA_PREFIX and (vim.env.CONDA_PREFIX .. "/bin/python") or nil,
        vim.fn.exepath("python3"),
        vim.fn.exepath("python"),
      })
      return python or "python3"
    end

    local function project_bin(name, root)
      root = root or project_root()
      local candidates = {
        root .. "/.venv/bin/" .. name,
        root .. "/" .. name,
        root .. "/scripts/" .. name,
      }
      for _, candidate in ipairs(candidates) do
        if vim.fn.executable(candidate) == 1 or vim.fn.filereadable(candidate) == 1 then
          return candidate
        end
      end
      local global_bin = vim.fn.exepath(name)
      if global_bin ~= "" then
        return global_bin
      end
      return nil
    end

    local function resolve_program(program, root)
      if not program or program == "" then
        return nil
      end
      if vim.fn.filereadable(program) == 1 or vim.fn.executable(program) == 1 then
        return program
      end
      if root then
        local rooted = root .. "/" .. program
        if vim.fn.filereadable(rooted) == 1 or vim.fn.executable(rooted) == 1 then
          return rooted
        end
      end
      local from_path = vim.fn.exepath(program)
      if from_path ~= "" then
        return from_path
      end
      return nil
    end

    local function read_history()
      if vim.fn.filereadable(history_file) == 0 then
        return {}
      end
      return vim.fn.readfile(history_file)
    end

    local function save_history(line)
      if line == nil or line == "" then
        return
      end

      local seen = {}
      local lines = { line }
      seen[line] = true

      for _, old in ipairs(read_history()) do
        if old ~= "" and not seen[old] then
          table.insert(lines, old)
          seen[old] = true
        end
      end

      while #lines > 30 do
        table.remove(lines)
      end

      vim.fn.writefile(lines, history_file)
    end

    local function split_args(line)
      local args = {}
      for arg in string.gmatch(line or "", "%S+") do
        table.insert(args, arg)
      end
      return args
    end

    local function append_debug(message)
      vim.fn.mkdir(vim.fs.dirname(debug_log), "p")
      vim.fn.writefile({ os.date("!%Y-%m-%dT%H:%M:%SZ") .. " " .. message }, debug_log, "a")
    end

    local dap_repl_winbar = "%#WinSeparator#%{repeat('─', winwidth(0))}"
    local dapui_side_width = 40
    local dapui_side_panels = {
      { id = "scopes", filetype = "dapui_scopes", label = "scopes" },
      { id = "stacks", filetype = "dapui_stacks", label = "stacks" },
      { id = "watches", filetype = "dapui_watches", label = "watches" },
      { id = "breakpoints", filetype = "dapui_breakpoints", label = "breakpoints" },
    }
    local dapui_side_state = {
      scopes = false,
      stacks = false,
      watches = false,
      breakpoints = false,
    }
    local dapui_side_filetypes = {}
    for _, panel in ipairs(dapui_side_panels) do
      dapui_side_filetypes[panel.filetype] = true
    end

    local function window_filetype(win)
      local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
      if not ok then
        return ""
      end
      return vim.bo[buf].filetype
    end

    local function is_floating_window(win)
      local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
      return ok and cfg.relative ~= ""
    end

    local function is_dapui_side_window(win)
      return dapui_side_filetypes[window_filetype(win)] == true
    end

    local function is_debug_window(win)
      local ft = window_filetype(win)
      return ft == "dap-repl" or ft == "dapui_console" or vim.startswith(ft, "dapui_")
    end

    local function dapui_layout_is_open(index)
      local ok_windows, windows = pcall(require, "dapui.windows")
      if not ok_windows or not windows.layouts or not windows.layouts[index] then
        return false
      end
      local layout = windows.layouts[index]
      local ok_open, is_open = pcall(layout.is_open, layout)
      return ok_open and is_open or false
    end

    local function dapui_bottom_repl_is_open()
      return dapui_layout_is_open(1)
    end

    local function dapui_is_open()
      if dapui_bottom_repl_is_open() then
        return true
      end
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local ft = window_filetype(win)
        if vim.startswith(ft, "dapui_") or ft == "dapui_console" then
          return true
        end
      end
      return false
    end

    local function dap_repl_height()
      return math.max(8, math.floor((vim.o.lines - vim.o.cmdheight - 1) * 0.35))
    end

    local function configure_dap_repl_windows()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(win) and window_filetype(win) == "dap-repl" then
          pcall(function()
            vim.wo[win].winbar = dap_repl_winbar
            vim.wo[win].winfixheight = true
            if not is_floating_window(win) then
              vim.api.nvim_win_set_height(win, dap_repl_height())
            end
          end)
        end
      end
    end

    local function close_standalone_repl()
      if dapui_bottom_repl_is_open() then
        return
      end
      local ok_repl, closed_or_err = pcall(function()
        return dap.repl.close({ mode = "toggle" })
      end)
      append_debug("dap.repl.close ok=" .. tostring(ok_repl) .. " closed=" .. vim.inspect(closed_or_err))
    end

    local function open_dapui_repl()
      close_standalone_repl()
      local ok_ui, ui_err = pcall(function()
        dapui.open({ layout = 1, reset = true })
      end)
      append_debug("dapui.open repl ok=" .. tostring(ok_ui) .. " err=" .. vim.inspect(ui_err))
      configure_dap_repl_windows()
      vim.schedule(configure_dap_repl_windows)
    end

    local function close_dapui_side_windows()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(win) and is_dapui_side_window(win) then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end
    end

    local function source_window()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(win) and not is_floating_window(win) and not is_debug_window(win) then
          return win
        end
      end
      return vim.api.nvim_get_current_win()
    end

    local function active_dapui_side_panels()
      local active = {}
      for _, panel in ipairs(dapui_side_panels) do
        if dapui_side_state[panel.id] then
          table.insert(active, panel)
        end
      end
      return active
    end

    local function configure_dapui_side_window(win)
      local options = {
        number = false,
        relativenumber = false,
        foldcolumn = "0",
        signcolumn = "no",
        wrap = false,
        winfixwidth = true,
      }
      for name, value in pairs(options) do
        pcall(function()
          vim.wo[win][name] = value
        end)
      end
      pcall(vim.api.nvim_win_set_width, win, dapui_side_width)
    end

    local function render_dapui_side_panels()
      local restore_win = vim.api.nvim_get_current_win()
      local split_win = source_window()
      local active = active_dapui_side_panels()

      close_dapui_side_windows()
      if #active == 0 then
        if vim.api.nvim_win_is_valid(restore_win) then
          pcall(vim.api.nvim_set_current_win, restore_win)
        end
        return
      end

      if vim.api.nvim_win_is_valid(split_win) then
        pcall(vim.api.nvim_set_current_win, split_win)
      end

      local created = {}
      for index, panel in ipairs(active) do
        if index == 1 then
          vim.cmd("topleft " .. dapui_side_width .. "vsplit")
        else
          vim.cmd("belowright split")
        end

        local win = vim.api.nvim_get_current_win()
        local elem = dapui.elements[panel.id]
        if elem then
          pcall(elem.render)
          local ok_buf, buf = pcall(elem.buffer)
          if ok_buf and buf and vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_win_set_buf(win, buf)
          end
        end
        configure_dapui_side_window(win)
        table.insert(created, win)
      end

      if #created > 0 then
        pcall(vim.api.nvim_win_set_width, created[1], dapui_side_width)
        local total_height = 0
        for _, win in ipairs(created) do
          if vim.api.nvim_win_is_valid(win) then
            total_height = total_height + vim.api.nvim_win_get_height(win)
          end
        end
        local each_height = math.max(3, math.floor(total_height / #created))
        for _, win in ipairs(created) do
          if vim.api.nvim_win_is_valid(win) then
            pcall(vim.api.nvim_win_set_height, win, each_height)
          end
        end
      end

      pcall(dapui.update_render, {})
      if vim.api.nvim_win_is_valid(restore_win) then
        pcall(vim.api.nvim_set_current_win, restore_win)
      elseif vim.api.nvim_win_is_valid(split_win) then
        pcall(vim.api.nvim_set_current_win, split_win)
      end
    end

    local function toggle_dapui_side_panel(panel_id)
      dapui_side_state[panel_id] = not dapui_side_state[panel_id]
      render_dapui_side_panels()
      vim.notify("DAP " .. panel_id .. " panel " .. (dapui_side_state[panel_id] and "shown" or "hidden"), vim.log.levels.INFO)
    end

    local function close_dapui_side_panels()
      for name, _ in pairs(dapui_side_state) do
        dapui_side_state[name] = false
      end
      close_dapui_side_windows()
      vim.notify("DAP side panels closed", vim.log.levels.INFO)
    end

    local function toggle_dapui()
      if dapui_bottom_repl_is_open() then
        local ok_ui, ui_err = pcall(function()
          dapui.close({ layout = 1 })
        end)
        append_debug("dapui.close repl ok=" .. tostring(ok_ui) .. " err=" .. vim.inspect(ui_err))
        return
      end

      open_dapui_repl()
    end

    local function launch_python(label, program, argline)
      local file = current_file()
      local root = project_root(file)
      local resolved_program = resolve_program(program, root)
      append_debug("launch label=" .. tostring(label) .. " file=" .. tostring(file) .. " root=" .. root .. " program=" .. tostring(program) .. " resolved=" .. tostring(resolved_program) .. " argline=" .. tostring(argline))

      if not resolved_program then
        local msg = "DAP program not found from root " .. root .. ": " .. tostring(program)
        append_debug(msg)
        vim.notify(msg, vim.log.levels.ERROR)
        return
      end

      local python = project_python(root)
      local args = split_args(argline)
      local config = {
        type = "python",
        request = "launch",
        name = "Python: " .. label,
        program = resolved_program,
        args = args,
        cwd = root,
        python = python,
        env = {
          PYTHONPATH = root .. ((vim.env.PYTHONPATH and vim.env.PYTHONPATH ~= "") and (":" .. vim.env.PYTHONPATH) or ""),
        },
        console = "internalConsole",
        redirectOutput = true,
        justMyCode = false,
      }

      vim.notify("DAP root " .. root .. "\nprogram " .. resolved_program .. "\nargs " .. vim.inspect(args) .. "\npython " .. python .. "\nlog " .. debug_log, vim.log.levels.INFO)
      append_debug("config=" .. vim.inspect(config))
      dap.set_log_level("TRACE")
      open_dapui_repl()

      local ok, err = pcall(function()
        dap.run(config)
      end)
      append_debug("dap.run ok=" .. tostring(ok) .. " err=" .. vim.inspect(err) .. " session=" .. tostring(dap.session()))
      if not ok then
        vim.notify("dap.run failed: " .. vim.inspect(err), vim.log.levels.ERROR)
      end
    end

    local function pick_args(callback)
      local choices = { "Type new args" }
      for _, line in ipairs(read_history()) do
        table.insert(choices, line)
      end

      vim.ui.select(choices, { prompt = "DAP args" }, function(choice)
        if not choice then
          return
        end

        if choice ~= "Type new args" then
          save_history(choice)
          callback(choice)
          return
        end

        vim.ui.input({
          prompt = "args: ",
          default = vim.g.dap_last_args or "",
        }, function(line)
          if not line then
            return
          end
          vim.g.dap_last_args = line
          save_history(line)
          callback(line)
        end)
      end)
    end

    local function run_python_dap()
      local commands = {
        {
          label = "run",
          program = function() return project_bin("run") end,
        },
        {
          label = "preview",
          program = function() return project_bin("preview") end,
        },
        {
          label = "score",
          program = function() return project_bin("score") end,
        },
        {
          label = "python current file",
          program = function() return current_file() end,
        },
        {
          label = "custom executable",
          program = function(done)
            vim.ui.input({
              prompt = "program: ",
              default = vim.g.dap_last_program or project_bin("run") or (project_root() .. "/"),
              completion = "file",
            }, function(program)
              if not program then
                return
              end
              vim.g.dap_last_program = program
              done(program)
            end)
          end,
          async = true,
        },
      }

      vim.ui.select(commands, {
        prompt = "DAP command",
        format_item = function(item)
          return item.label
        end,
      }, function(choice)
        if not choice then
          return
        end

        local function launch(program)
          pick_args(function(argline)
            launch_python(choice.label, program, argline)
          end)
        end

        if choice.async then
          choice.program(launch)
        else
          launch(choice.program())
        end
      end)
    end

    require("dap-python").setup("${debugpyPython}/bin/python")

    local function dap_repl_until(args)
      local arg = vim.trim(args or "")
      if arg == "" then
        vim.notify("DAP until requires line number: until <line>", vim.log.levels.WARN)
        return
      end
      if not arg:match("^%d+$") then
        vim.notify("DAP until expects line number in current file: until <line>", vim.log.levels.WARN)
        return
      end

      local line = tonumber(arg)
      local file = current_file()
      if not file then
        vim.notify("DAP until needs current Python file", vim.log.levels.ERROR)
        return
      end

      local bufnr = vim.fn.bufnr(file, 1)
      if bufnr < 0 then
        vim.notify("DAP until cannot load file: " .. file, vim.log.levels.ERROR)
        return
      end
      if not vim.api.nvim_buf_is_loaded(bufnr) then
        vim.fn.bufload(bufnr)
      end

      local line_count = vim.api.nvim_buf_line_count(bufnr)
      if line < 1 or line > line_count then
        vim.notify("DAP until line out of range: " .. line .. " (1-" .. line_count .. ")", vim.log.levels.WARN)
        return
      end

      local session = dap.session()
      if not session then
        vim.notify("DAP until needs active session", vim.log.levels.WARN)
        return
      end
      if not session.stopped_thread_id then
        vim.notify("DAP until only works while debugger is stopped", vim.log.levels.WARN)
        return
      end

      local breakpoints = require("dap.breakpoints")
      local bps_before = breakpoints.get()
      breakpoints.clear()
      breakpoints.set({}, bufnr, line)

      local temp_bps = breakpoints.get(bufnr)
      for old_bufnr, _ in pairs(bps_before) do
        if old_bufnr ~= bufnr then
          temp_bps[old_bufnr] = {}
        end
      end
      if bps_before[bufnr] == nil then
        bps_before[bufnr] = {}
      end

      local listener_key = "dap.repl_until"
      local restored = false
      local function restore_breakpoints()
        if restored then
          return
        end
        restored = true
        dap.listeners.before.event_stopped[listener_key] = nil
        dap.listeners.before.event_terminated[listener_key] = nil
        dap.listeners.before.event_exited[listener_key] = nil
        breakpoints.clear()
        for buf, buf_bps in pairs(bps_before) do
          for _, bp in pairs(buf_bps) do
            breakpoints.set({
              condition = bp.condition,
              log_message = bp.logMessage,
              hit_condition = bp.hitCondition,
            }, buf, bp.line)
          end
        end
        pcall(session.set_breakpoints, session, bps_before, nil)
      end

      dap.listeners.before.event_stopped[listener_key] = restore_breakpoints
      dap.listeners.before.event_terminated[listener_key] = restore_breakpoints
      dap.listeners.before.event_exited[listener_key] = restore_breakpoints
      session:set_breakpoints(temp_bps, function()
        session:_step("continue")
      end)
      vim.notify("DAP until " .. vim.fn.fnamemodify(file, ":t") .. ":" .. line, vim.log.levels.INFO)
    end

    local function setup_dap_repl_aliases()
      local repl = require("dap.repl")
      repl.commands.custom_commands.n = function()
        dap.step_over()
      end
      repl.commands.custom_commands.s = function()
        dap.step_into()
      end
      repl.commands.custom_commands.c = function()
        dap.continue()
      end
      repl.commands.custom_commands["until"] = dap_repl_until
    end

    setup_dap_repl_aliases()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      append_debug("event_initialized")
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      vim.notify("DAP terminated", vim.log.levels.INFO)
    end
    dap.listeners.before.event_exited["dapui_config"] = function(_, body)
      local code = body and body.exitCode
      vim.notify("DAP exited with code " .. tostring(code), code and code ~= 0 and vim.log.levels.WARN or vim.log.levels.INFO)
    end

    local function dap_python_info()
      local file = current_file()
      local root = project_root(file)
      local lines = {
        "file: " .. tostring(file),
        "root: " .. root,
        "cwd: " .. vim.fn.getcwd(),
        "python: " .. project_python(root),
        "run: " .. tostring(project_bin("run", root)),
        "preview: " .. tostring(project_bin("preview", root)),
        "score: " .. tostring(project_bin("score", root)),
        "debugpy: ${debugpyPython}/bin/python",
        "debug log: " .. debug_log,
      }
      vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
      append_debug("info " .. table.concat(lines, " | "))
    end

    local function dap_python_run(opts)
      local parts = split_args(opts.args)
      local command = parts[1]
      local label = command or "run"
      local program = nil

      if command == "run" or command == nil then
        program = project_bin("run")
        if command == "run" then
          table.remove(parts, 1)
        end
        label = "run"
      elseif command == "preview" then
        program = project_bin("preview")
        table.remove(parts, 1)
      elseif command == "score" then
        program = project_bin("score")
        table.remove(parts, 1)
      elseif command == "current" or command == "file" then
        program = current_file()
        table.remove(parts, 1)
        label = "python current file"
      else
        program = project_bin("run")
        label = "run"
      end

      launch_python(label, program, table.concat(parts, " "))
    end

    vim.api.nvim_create_user_command("DapPythonCommand", run_python_dap, {
      desc = "Pick a Python command and run it under DAP",
    })
    local function toggle_dap_virtual_text()
      local vt = require("nvim-dap-virtual-text")
      vt.toggle()
      local enabled = vt.is_enabled()
      vim.notify("DAP virtual text " .. (enabled and "enabled" or "disabled"), enabled and vim.log.levels.INFO or vim.log.levels.WARN)
    end

    vim.api.nvim_create_user_command("DapUIToggle", toggle_dapui, {
      desc = "Toggle DAP UI without duplicating the DAP REPL",
    })
    vim.api.nvim_create_user_command("DapUIScopesToggle", function()
      toggle_dapui_side_panel("scopes")
    end, {
      desc = "Toggle DAP scopes side panel",
    })
    vim.api.nvim_create_user_command("DapUIStacksToggle", function()
      toggle_dapui_side_panel("stacks")
    end, {
      desc = "Toggle DAP stacks side panel",
    })
    vim.api.nvim_create_user_command("DapUIWatchesToggle", function()
      toggle_dapui_side_panel("watches")
    end, {
      desc = "Toggle DAP watches side panel",
    })
    vim.api.nvim_create_user_command("DapUIBreakpointsToggle", function()
      toggle_dapui_side_panel("breakpoints")
    end, {
      desc = "Toggle DAP breakpoints side panel",
    })
    vim.api.nvim_create_user_command("DapUISideClose", close_dapui_side_panels, {
      desc = "Close DAP side panels",
    })
    vim.api.nvim_create_user_command("DapGhostTextToggle", toggle_dap_virtual_text, {
      desc = "Toggle DAP virtual text with status message",
    })
    vim.api.nvim_create_user_command("DapVirtualTextToggle", toggle_dap_virtual_text, {
      desc = "Toggle DAP virtual text with status message",
      force = true,
    })
    vim.api.nvim_create_user_command("DapPythonRun", dap_python_run, {
      nargs = "*",
      desc = "Run Python command under DAP: run|preview|score|current [args...]",
      complete = function(arglead, cmdline)
        local argc = #split_args(cmdline)
        if argc <= 1 then
          return vim.tbl_filter(function(item)
            return vim.startswith(item, arglead)
          end, { "run", "preview", "score", "current" })
        end
        return {}
      end,
    })
    vim.api.nvim_create_user_command("DapPythonInfo", dap_python_info, {
      desc = "Show resolved Python DAP file, root, interpreter, and commands",
    })
    vim.api.nvim_create_user_command("DapPythonLogs", function()
      require("dap._cmds").show_logs()
    end, {
      desc = "Open nvim-dap logs",
    })
    vim.api.nvim_create_user_command("DapPythonDebugLog", function()
      vim.cmd.edit(debug_log)
    end, {
      desc = "Open Python DAP command debug log",
    })

    vim.keymap.set("n", "<leader>dC", run_python_dap, {
      silent = true,
      desc = "DAP Python command picker",
    })
    vim.keymap.set("n", "<leader>dR", ":DapPythonRun run ", {
      desc = "DAP Python run command",
    })
  '';

  plugins.lualine = {
    settings = {
      options = {
        ignore_focus = [
          "dapui_scopes"
          "dapui_breakpoints"
          "dapui_stacks"
          "dapui_watches"
          "dap-repl"
          "dapui_console"
        ];
      };
    };
  };

}
