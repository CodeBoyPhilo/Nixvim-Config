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

}
