{ lib, config, ... }:

let
  cfg = config.theme.tokyonight;
in {
  options.theme.tokyonight.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable the Tokyonight colorscheme.";
  };

  config = lib.mkIf cfg.enable {
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night";
        transparent = false;
        styles = {
          floats = "transparent";
          sidebars = "transparent";
          comments.italic = true;
          functions.italic = true;
          variables.italic = false;
          keywords = {
            italic = true;
            bold = true;
          };
        };
        on_highlights = # lua
          ''
            function(hl, c)
              local prompt = "#2d3149"
              hl.TelescopeNormal = {
                bg = c.bg_dark,
                fg = c.fg_dark,
              }
              hl.TelescopeBorder = {
                bg = c.bg_dark,
                fg = c.bg_dark,
              }
              hl.TelescopePromptNormal = {
                bg = prompt,
              }
              hl.TelescopePromptBorder = {
                bg = prompt,
                fg = prompt,
              }
              hl.TelescopePromptTitle = {
                bg = prompt,
                fg = prompt,
              }
              hl.TelescopePreviewTitle = {
                bg = c.bg_dark,
                fg = c.bg_dark,
              }
              hl.TelescopeResultsTitle = {
                bg = c.bg_dark,
                fg = c.bg_dark,
              }
            end
          '';
      };
    };

    plugins.bufferline.settings.highlights.fill.bg = lib.mkForce "#1a1b26";
    plugins.telescope.highlightTheme = "tokyonight";

    extraConfigLua = ''
      vim.api.nvim_set_hl(0, "WinBar", {bg = "#1a1b26"})
    '';
  };
}
