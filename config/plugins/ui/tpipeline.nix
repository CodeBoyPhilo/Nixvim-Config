{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Add the plugin via extraPlugins
  extraPlugins = with pkgs.vimPlugins; [
    vim-tpipeline
  ];

  extraConfigLua = ''
    -- Enable tpipeline
    vim.g.tpipeline_active = 1

    -- Update interval in ms
    vim.g.tpipeline_refresh = 10

    -- Preserve tmux status right section
    vim.g.tpipeline_preservebg = 0

    -- Restore cursor when exiting
    vim.g.tpipeline_restore_on_exit = 1

    -- Set fillchars for optimum display
    vim.opt.fillchars:append({ eob = " " })
  '';
}
