{
  plugins.dropbar = {
    enable = true;
  };
  # delete extraConfigLua for catppuccin
  extraConfigLua = ''
    vim.api.nvim_set_hl(0, "WinBar", {bg = "#1a1b26"})
    	'';
}
