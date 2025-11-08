{ lib, config, ... }:

let
  cfg = config.theme.catppuccin;
in
{
  options.theme.catppuccin.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the Catppuccin colorscheme.";
  };

  config = lib.mkIf cfg.enable {
    theme.tokyonight.enable = lib.mkForce false;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = true;
        custom_highlights = ''
            function(colors)
              return {
                BufferLineBackground = { bg = "NONE" },
                BufferLineFill = { bg = "NONE" },
                BufferLineTab = { bg = "NONE" },
                BufferLineTabSelected = { bg = "NONE" },
                BufferLineTabClose = { bg = "NONE" },
                Comment = { fg = colors.surface2, style = { "italic" } },
                Constant = { fg = colors.peach },
                String = { fg = colors.green},
                Character = { fg = colors.teal },
                Number = { fg = colors.maroon },
                Float = { fg = colors.maroon },
                Boolean = { fg = colors.maroon },
                Identifier = { fg = colors.text },
                Function = { fg = colors.blue, style = {"italic"}},
                Statement = { fg = colors.mauve, style = {"italic", "bold"}},
                Conditional = { fg = colors.red },
                Repeat = { fg = colors.red },
                Label = { fg = colors.sapphire},
                Operator = { fg = colors.text },
                Keyword = { fg = colors.mauve, style = { "italic", "bold"}},
                PreProc = { fg = colors.sapphire},
                Include = { fg = colors.sky},
                StorageClass = { fg = colors.mauve},
                Structure = { fg = colors.yellow },
                Typedef = { fg = colors.yellow },
                Special = { fg = colors.sapphire},
                Type = { fg = colors.sapphire},
                ["@include"] = { fg = colors.sapphire, style = { "italic" } },
                ["@field"] = { fg = colors.blue },
                ["@property"] = { fg = colors.blue },
                ["@constant.builtin"] = { fg = colors.maroon },
                ["@parameter"] = { fg = colors.yellow,},
                ["@operator"] = { fg = colors.text },
                ["@keyword.function"] = { fg = colors.mauve, style = { "italic" }},
                ["@keyword"] = { fg = colors.mauve, style = {"italic", "bold"}},
                ["@keyword.return"] = { fg = colors.mauve},
                ["@type"] = { fg = colors.sapphire},
                ["@type.builtin"] = { fg = colors.lavender, },
                ["@variable.builtin"] = { fg = colors.red },
                ["@function.builtin"] = { fg = colors.green },
                ["@function"] = { fg = colors.green },
                ["@string"] = { fg = colors.green, },
                BufferLineSeparator = { fg = colors.sapphire, bg = "NONE" },
                BufferLineBufferVisible = { fg = colors.surface1, bg = "NONE" },
                BufferLineBufferSelected = { fg = colors.text, bg = "NONE", style = { "bold", "italic" } },
                BufferLineIndicatorSelected = { fg = colors.sapphire, bg = "NONE" },
                DbFindFile = { fg = colors.teal, style = { "bold" } },
              DbFindWord = { fg = colors.green, style = { "bold" } },
              DbConfig = { fg = colors.yellow, style = { "bold" } },
              DbQuit = { fg = colors.maroon, style = { "bold" } },
               DbSeparator = { fg = colors.text, style = { "bold" } },
               TreesitterContext = { bg = colors.surface0 },
               TreesitterContextLineNumber = { bg = colors.surface0 },
               TreesitterContextSeparator = { fg = colors.overlay1, bg = colors.surface0 },
               TreesitterContextBottom = { style = { "underline" }, sp = colors.overlay1, bg = colors.surface0 },
             }

          end
        '';

      };
    };

    plugins.bufferline.settings.highlights.fill.bg = lib.mkForce "NONE";
    plugins.telescope.highlightTheme = "Catppuccin Mocha";
  };
}
