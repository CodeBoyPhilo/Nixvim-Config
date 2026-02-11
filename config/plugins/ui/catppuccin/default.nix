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
        # Use transparent background only when NOT in Neovide
        transparent_background = true;
        term_colors = true;
        custom_highlights = ''
          function(colors)
          	local is_neovide = vim.g.neovide ~= nil
          	local bg = is_neovide and colors.base or "NONE"
          	local bufferline_bg = is_neovide and colors.mantle or "NONE"
          	
          	return {
          		-- Set proper background for Neovide
          		Normal = { bg = bg },
          		NormalNC = { bg = bg },
          		
          		-- BufferLine backgrounds
          		BufferLineBackground = { bg = bufferline_bg },
          		BufferLineFill = { bg = bufferline_bg },
          		BufferLineTab = { bg = bufferline_bg },
          		BufferLineTabSelected = { bg = bg },
          		BufferLineTabClose = { bg = bufferline_bg },
          		
          		-- Syntax highlighting
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
          		
          		-- Treesitter
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
          		
          		-- BufferLine colors
          		BufferLineSeparator = { fg = colors.sapphire, bg = bufferline_bg },
          		BufferLineBufferVisible = { fg = colors.surface1, bg = bufferline_bg },
          		BufferLineBufferSelected = { fg = colors.text, bg = bg, style = { "bold", "italic" } },
          		BufferLineIndicatorSelected = { fg = colors.sapphire, bg = bg },
          		
          		-- Dashboard
          		DbFindFile = { fg = colors.teal, style = { "bold" } },
          		DbFindWord = { fg = colors.green, style = { "bold" } },
          		DbConfig = { fg = colors.yellow, style = { "bold" } },
          		DbQuit = { fg = colors.maroon, style = { "bold" } },
          		DbSeparator = { fg = colors.text, style = { "bold" } },
          		
          		-- Treesitter context
          		TreesitterContext = { bg = colors.surface1 },
          		TreesitterContextLineNumber = { bg = colors.surface0 },
          		TreesitterContextSeparator = { fg = colors.overlay1, bg = colors.surface0 },
          		TreesitterContextBottom = { style = { "underline" }, sp = colors.overlay1, bg = colors.surface0 },
          		
          		-- Float windows - keep transparent unless in Neovide
          		NormalFloat = { bg = is_neovide and colors.mantle or "NONE"},
          		FloatBorder = { fg = colors.text, bg = is_neovide and colors.mantle or "NONE"},
          		FloatTitle = { fg = colors.text, bg = is_neovide and colors.mantle or "NONE"},

				-- Terminal background - match themed background in Neovide
				Terminal = { bg = is_neovide and colors.base or "NONE" },
          		
          		-- Cursor line - use subtle background in Neovide
          		CursorLine = { bg = is_neovide and colors.surface0 or "NONE"},
          		
          		-- Dropbar backgrounds
          		DropBarMenuNormalFloat = { bg = is_neovide and colors.mantle or "NONE" },
          		DropBarMenuHoverEntry = { bg = colors.surface0 },
          		DropBarMenuHoverIcon = { bg = colors.surface0 },
          		DropBarMenuCurrentContext = { bg = colors.surface1 },
          	}
          end
        '';

      };
    };

    plugins.bufferline.settings.highlights.fill.bg = lib.mkForce "NONE";
    plugins.telescope.highlightTheme = "Catppuccin Mocha";
  };
}
