{
  plugins.molten = {
    enable = true;
    settings = {
      auto_open_output = false;
      wrap_output = true;
      virt_text_output = true;
      virt_lines_off_by_1 = true;
    };
  };

  plugins.quarto = {
    enable = true;
    settings = {
      lspFeatures = {
        languages = [ "python" ];
        chunks = "all";
      };
      codeRunner = {
        enabled = true;
        default_method = "molten";
      };
    };
  };

  autoCmd = [
    {
      event = "FileType";
      pattern = "python";
      desc = "Activate Quarto in Python buffers";
      callback.__raw = ''function() require("quarto").activate() end'';
    }
  ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>mi";
      action = "<cmd>MoltenInit<cr>";
      options.desc = "Initialise Molten";
    }
    {
      mode = "n";
      key = "<leader>mr";
      action = "<cmd>MoltenEvaluateOperator<cr>";
      options.desc = "Molten Evaluate Operator";
    }
    {
      mode = "n";
      key = "<leader>ms";
      action = "<cmd>noautocmd MoltenEnterOutput<cr>";
      options.desc = "Molten Open Output Window";
    }

    {
      mode = "n";
      key = "<leader>rc";
      action.__raw = ''require("quarto.runner").run_cell'';
      options.desc = "Quarto Run Cell";
    }
    {
      mode = "n";
      key = "<leader>ra";
      action.__raw = ''require("quarto.runner").run_above'';
      options.desc = "Quarto Run Cell and Above";
    }
    {
      mode = "n";
      key = "<leader>rA";
      action.__raw = ''require("quarto.runner").run_all'';
      options.desc = "Quarto Run All Cells";
    }
    {
      mode = "n";
      key = "<leader>rl";
      action.__raw = ''require("quarto.runner").run_line'';
      options.desc = "Quarto Run Line";
    }
    {
      mode = "v";
      key = "<leader>r";
      action.__raw = ''require("quarto.runner").run_range'';
      options.desc = "Quarto Run Visual Range";
    }
    {
      mode = "n";
      key = "<leader>RA";
      action.__raw = ''function() require("quarto.runner").run_all(true) end'';
      options.desc = "Quarto Run All Cells of All Language";
    }
  ];
}
