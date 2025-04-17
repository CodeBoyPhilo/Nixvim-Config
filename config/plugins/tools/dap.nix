{
  plugins = {
    dap-virtual-text = {
      enable = true;
      settings = {
        commented = true; # Show virtual text alongside comment
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
      settings = { };
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
      action = "<cmd>lua require('dapui').toggle()<CR>";
      options = {
        silent = true;
        desc = "Toggle debug UI";
      };
    }
  ];
}
