{
  # Vim options
  opts = {
    # Line numbers
    number = true;
    relativenumber = true;

    # Tabs & indentation
    tabstop = 2;
    shiftwidth = 2;
    expandtab = false;
    autoindent = true;

    # Search settings
    ignorecase = true;
    smartcase = true;

    # UI settings
    cursorline = true;
    termguicolors = true;
    background = "dark";
    signcolumn = "yes";
		conceallevel = 1;

    # Backspace behavior
    backspace = "indent,eol,start";

    # Split window behavior
    splitright = true;
    splitbelow = true;
  };

  # Global variables
  globals = {
    # Netrw list style
    netrw_liststyle = 3;
    neovide_hide_mouse_when_typing = true;

		# Format
		disable_autoformat = true;
  };

  # Clipboard settings
  clipboard = {
    register = "unnamedplus";
  };
}
