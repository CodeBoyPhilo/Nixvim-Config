{
  plugins.yazi = {
    enable = true;
    settings = {
      enable_mouse_support = true;
      hooks = {
        yazi_closed_successfully.__raw = ''
          function(chosen_file, config, state)
            if not chosen_file or chosen_file == "" then
              return
            end

            vim.schedule(function()
              local absolute_path = vim.fn.fnamemodify(chosen_file, ":p")
              if not absolute_path or absolute_path == "" then
                return
              end

              local uv = vim.uv or vim.loop
              local stat = uv and uv.fs_stat(absolute_path) or nil

              local dir
              local reveal_file

              if stat and stat.type == "directory" then
                dir = absolute_path
              else
                reveal_file = absolute_path
                dir = vim.fs.dirname(absolute_path)
              end

              if not dir or dir == "" then
                dir = vim.fn.fnamemodify(absolute_path, ":p:h")
              end

              if not dir or dir == "" then
                return
              end

              local has_manager, manager = pcall(require, "neo-tree.sources.manager")
              local state = nil
              if has_manager then
                state = manager.get_state("filesystem", nil, nil)
                if state then
                  state.path = dir
                  state.dirty = true
                end
              end

              local has_command, command = pcall(require, "neo-tree.command")
              if not has_command then
                return
              end

              local has_renderer, renderer = pcall(require, "neo-tree.ui.renderer")
              if not has_renderer or not state or not renderer.window_exists(state) then
                return
              end

              local args = {
                source = "filesystem",
                action = "show",
                toggle = false,
                reveal_force_cwd = true,
                dir = dir,
              }

              if reveal_file then
                args.reveal_file = reveal_file
              end

              command.execute(args)
            end)
          end
        '';
      };
    };
  };


  keymaps = [
    {
      key = "<leader>y";
      action = "<cmd>Yazi<CR>";
      mode = "n";
      options.desc = "Open Yazi at the current file";
    }
  ];
}
