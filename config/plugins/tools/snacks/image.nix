{ lib, ... }:
{
  plugins.snacks = {
    settings = {
      image = {
        enabled = lib.generators.mkLuaInline "not vim.g.neovide";
        convert = {
          notify = false;
        };
      };
    };
  };
}
