{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        ignore_focus = [
          "neo-tree"
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
