{
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";
      transparent_background = true;
      custom_highlights = ''
        function(colors)
          return {
            Comment = { fg = colors.surface2, style = { "italic" } },
            Constant = { fg = colors.peach },
            String = { fg = colors.yellow, style = { "italic", "bold" } },
            Character = { fg = colors.teal },
            Number = { fg = colors.maroon },
            Float = { fg = colors.maroon },
            Boolean = { fg = colors.maroon },
            Identifier = { fg = colors.text },
            Function = { fg = colors.green },
            Statement = { fg = colors.mauve },
            Conditional = { fg = colors.red },
            Repeat = { fg = colors.red },
            Label = { fg = colors.peach },
            Operator = { fg = colors.text },
            Keyword = { fg = colors.pink },
            PreProc = { fg = colors.peach },
            Include = { fg = colors.green },
            StorageClass = { fg = colors.yellow },
            Structure = { fg = colors.yellow },
            Typedef = { fg = colors.yellow },
            Special = { fg = colors.peach },
            Type = { fg = colors.teal },
            ["@include"] = { fg = colors.peach, style = { "italic" } },
            ["@field"] = { fg = colors.blue },
            ["@property"] = { fg = colors.blue },
            ["@constant.builtin"] = { fg = colors.maroon },
            ["@parameter"] = { fg = colors.text, style = { "italic" } },
            ["@operator"] = { fg = colors.text },
            ["@keyword.function"] = { fg = colors.peach },
            ["@keyword"] = { fg = colors.peach },
            ["@keyword.return"] = { fg = colors.peach },
            ["@type"] = { fg = colors.teal },
            ["@type.builtin"] = { fg = colors.teal, style = { "italic" } },
            ["@variable.builtin"] = { fg = colors.red },
            ["@function.builtin"] = { fg = colors.green },
            ["@function"] = { fg = colors.green },
            ["@string"] = { fg = colors.yellow, style = { "italic" } },
            BufferLineSeparator = { fg = colors.peach, bg = "NONE" },
            BufferLineBufferVisible = { fg = colors.surface1, bg = "NONE" },
            BufferLineBufferSelected = { fg = colors.text, bg = "NONE", style = { "bold", "italic" } },
            BufferLineIndicatorSelected = { fg = colors.peach, bg = "NONE" },
            DbFindFile = { fg = colors.teal, style = { "bold" } },
            DbFindWord = { fg = colors.green, style = { "bold" } },
            DbConfig = { fg = colors.yellow, style = { "bold" } },
            DbQuit = { fg = colors.maroon, style = { "bold" } },
            DbSeparator = { fg = colors.text, style = { "bold" } },
          }
        end
      '';
    };
  };
}
