{
  globals.mapleader = " ";

  keymaps = [
    # Insert mode: Exit insert mode with 'jk'
    {
      mode = "i";
      key = "jk";
      action = "<ESC>";
      options.desc = "Exit insert mode with jk";
    }

    # Normal mode: Paste with System Clipboard with 'shift + ctrl + v'
    {
      mode = "n";
      key = "<C-S-v>";
      action = "+p";
      options.desc = "Paste from clipboard";
    }

    # Normal mode: Clear search highlights
    {
      mode = "n";
      key = "<leader>nh";
      action = ":nohl<CR>";
      options.desc = "Clear search highlights";
    }

    # Normal mode: Increment/decrement numbers
    {
      mode = "n";
      key = "<leader>+";
      action = "<C-a>";
      options.desc = "Increment number";
    }
    {
      mode = "n";
      key = "<leader>-";
      action = "<C-x>";
      options.desc = "Decrement number";
    }

    # Window management
    {
      mode = "n";
      key = "<leader>sv";
      action = "<C-w>v";
      options.desc = "Split window vertically";
    }
    {
      mode = "n";
      key = "<leader>sh";
      action = "<C-w>s";
      options.desc = "Split window horizontally";
    }
    {
      mode = "n";
      key = "<leader>se";
      action = "<C-w>=";
      options.desc = "Make splits equal size";
    }
    {
      mode = "n";
      key = "<leader>sx";
      action = "<cmd>close<CR>";
      options.desc = "Close current split";
    }

    # Tab management
    {
      mode = "n";
      key = "<leader>to";
      action = "<cmd>tabnew<CR>";
      options.desc = "Open new tab";
    }
    {
      mode = "n";
      key = "<leader>tx";
      action = "<cmd>tabclose<CR>";
      options.desc = "Close current tab";
    }
    {
      mode = "n";
      key = "<leader>tn";
      action = "<cmd>tabn<CR>";
      options.desc = "Go to next tab";
    }
    {
      mode = "n";
      key = "<leader>tp";
      action = "<cmd>tabp<CR>";
      options.desc = "Go to previous tab";
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>tabnew %<CR>";
      options.desc = "Open current buffer in new tab";
    }

    # Indent and dedent lines in visual mode
    {
      mode = "v";
      key = "<Tab>";
      action = ">gv";
      options = {
        noremap = true;
        silent = true;
        desc = "Indent selected lines";
      };
    }
    {
      mode = "v";
      key = "<S-Tab>";
      action = "<gv";
      options = {
        noremap = true;
        silent = true;
        desc = "Dedent selected lines";
      };
    }

    # Indent and dedent lines in normal mode
    {
      mode = "n";
      key = "<Tab>";
      action = ">>";
      options = {
        noremap = true;
        silent = true;
        desc = "Indent current line";
      };
    }
    {
      mode = "n";
      key = "<S-Tab>";
      action = "<<";
      options = {
        noremap = true;
        silent = true;
        desc = "Dedent current line";
      };
    }
  ];
}
