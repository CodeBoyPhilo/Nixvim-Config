# { pkgs, ... }:
# {
#   extraPlugins = with pkgs.vimPlugins; [ nui-nvim ];
# }
{
  plugins.nui.enable = true;
}
