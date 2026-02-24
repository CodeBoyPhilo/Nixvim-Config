{ lib, config, ... }:

let
  cfg = config.theme.maple;
in
{
  options.theme.maple.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the Maple Dark colorscheme.";
  };

  config = lib.mkIf cfg.enable {
    theme.tokyonight.enable = lib.mkForce false;
    theme.catppuccin.enable = lib.mkForce false;

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
                    		Normal = { bg = "#1e1e1f"},
                    		NormalNC = { bg = "#1e1e1f"},
                    		
                    		-- BufferLine backgrounds
                    		BufferLineBackground = { bg = bufferline_bg },
                    		BufferLineFill = { bg = bufferline_bg },
                    		BufferLineTab = { bg = bufferline_bg },
                    		BufferLineTabSelected = { bg = bg },
                    		BufferLineTabClose = { bg = bufferline_bg },
                    		
                    		-- Syntax highlighting
                    		Comment = { fg = "#999999", style = { "italic" } },
                    		Constant = { fg = "#f0c0a8" },
                    		String = { fg = "#a4dfae"},
                    		Character = { fg = "#b8d7f9" },
                    		Number = { fg = "#d5f288" },
                    		Float = { fg = "#d5f288" },
                    		Boolean = { fg = "#d2ccff" },
                    		Identifier = { fg = "#f0c0a8"},
                    		Function = { fg = "#8fc7ff", style = {"italic"}},
                    		Statement = { fg = "#d2ccff", style = {"italic"}},
          							Conditional = { fg = "#d2ccff" },
          							Repeat = { fg = "#d2ccff" },
                    		Label = { fg = "#cbd5e1"},
                    		Operator = { fg = "#b8d7f9" },
                    		Keyword = { fg = "#d2ccff", style = { "italic"}},
                    		PreProc = { fg = "#b8d7f9"},
                    		Include = { fg = "#8fc7ff"},
                    		StorageClass = { fg = "#d2ccff"},
                    		Structure = { fg = "#f0c0a8" },
                    		Typedef = { fg = "#d2ccff" },
                    		Special = { fg = "#b8d7f9"},
                    		Type = { fg = "#b8d7f9"},
                    		
                    		-- Treesitter
                    		["@include"] = { fg = "#b8d7f9", style = { "italic" } },
                    		["@field"] = { fg = "#8fc7ff" },
                    		["@property"] = { fg = "#ded6cf" },
          							["@constant.builtin"] = { fg = "#cbd5e1"},
          							["@parameter"] = { fg = "#8fc7ff" },
          							["@variable.parameter"] = { fg = "#8fc7ff" },
          							["@lsp.type.parameter"] = { fg = "#8fc7ff" },
          							["@lsp.typemod.parameter.declaration"] = { fg = "#8fc7ff" },
          							["@operator"] = { fg = "#e3cbeb" },
          							["@keyword"] = { fg = "#d2ccff", style = { "italic"} },
          							["@keyword.function"] = { fg = "#d2ccff", style = { "italic"} },
          							["@keyword.conditional"] = { fg = "#d2ccff", style = { "italic"} },
          							["@keyword.repeat"] = { fg = "#d2ccff", style = { "italic"} },
          							["@keyword.exception"] = { fg = "#d2ccff", style = { "italic"} },
          							["@keyword.type"] = { fg = "#d2ccff", style = { "italic"} },
          							["@keyword.operator"] = { fg = "#d2ccff", style = { "italic"} },
          							["@keyword.return"] = { fg = "#d2ccff"},
          							["@function.macro"] = { fg = "#d2ccff", style = { "italic" } },
          							["@function.macro.python"] = { fg = "#d2ccff", style = { "italic" } },
          							["@string.special"] = { fg = "#d2ccff", style = { "italic" } },
          							["@string.special.python"] = { fg = "#d2ccff", style = { "italic" } },
          							["@type"] = { fg = "#f0c0a8"},
          							["@type.builtin"] = { fg = "#ded6cf" },
          							["@type.builtin.python"] = { fg = "#ded6cf" },
          							["@exception"] = { fg = "#ded6cf" },
          							["@constructor"] = { fg = "#8fc7ff", italic = false },
          							["@constructor.python"] = { fg = "#8fc7ff", italic = false },
          							["@lsp.typemod.class.defaultLibrary"] = { fg = "#ded6cf" },
          							["@lsp.typemod.type.defaultLibrary"] = { fg = "#ded6cf" },
          							["@variable.builtin"] = { fg = "#8fc7ff" },
          							["@function.builtin"] = { fg = "#8fc7ff" },
          							["@function.builtin.python"] = { fg = "#8fc7ff" },
          							["@function"] = { fg = "#8fc7ff" },
                    		["@string"] = { fg = "#a4dfae", },
                    		
                    		-- BufferLine colors
                    		BufferLineSeparator = { fg = "#d2ccff", bg = bufferline_bg },
                    		BufferLineBufferVisible = { fg = "#cbd5e1", bg = bufferline_bg },
          							BufferLineBufferSelected = { fg = "#cbd5e1", bg = bg, style = { "bold", "italic" } },
                    		BufferLineIndicatorSelected = { fg = "#d2ccff", bg = "#1e1e1f" },
                    		
                    		-- Dashboard
                    		DbFindFile = { fg = colors.teal, style = { "bold" } },
                    		DbFindWord = { fg = colors.green, style = { "bold" } },
                    		DbConfig = { fg = colors.yellow, style = { "bold" } },
                    		DbQuit = { fg = colors.maroon, style = { "bold" } },
                    		DbSeparator = { fg = colors.text, style = { "bold" } },
                    		
                    		-- Treesitter context
          							TreesitterContext = { bg = "#3d4b5f" },
                    		TreesitterContextLineNumber = { bg = "#1e1e1f" },
                    		TreesitterContextSeparator = { fg = "#cbd5e1", bg = "#44444b" },
                    		TreesitterContextBottom = { style = { "underline" }, sp = "#cbd5e1", bg = "#44444b" },
                    		
                    		-- Float windows - keep transparent unless in Neovide
                    		NormalFloat = { bg = is_neovide and "#1e1e1f" or "NONE"},
                    		FloatBorder = { fg = colors.text, bg = is_neovide and "#1e1e1f" or "NONE"},
                    		FloatTitle = { fg = colors.text, bg = is_neovide and "#1e1e1f" or "NONE"},

          							-- Terminal background - match themed background in Neovide
          							Terminal = { bg = is_neovide and "#1e1e1f" or "NONE" },
                    		
                    		-- Cursor line - use subtle background in Neovide
                    		CursorLine = { bg = is_neovide and "#44444b" or "NONE"},
                    		
                    		-- Dropbar backgrounds
                    		DropBarMenuNormalFloat = { bg = is_neovide and "#1e1e1f" or "NONE" },
                    		DropBarMenuHoverEntry = { bg = "#64748b" },
                    		DropBarMenuHoverIcon = { bg = "#64748b" },
                    		DropBarMenuCurrentContext = { bg = "#3d4b5f"},
                    	}
                    end
        '';

      };
    };

    extraConfigLua = ''
            local catppuccin_python_query_override_version = 3
            if vim.g.catppuccin_python_highlight_query_override_version ~= catppuccin_python_query_override_version then
              local function apply_python_query_overrides()
                local query_files = vim.treesitter.query.get_files("python", "highlights")
                if #query_files == 0 then
                  return false
                end

                local chunks = {}
                for _, query_file in ipairs(query_files) do
                  local lines = vim.fn.readfile(query_file)
                  if #lines > 0 then
                    table.insert(chunks, table.concat(lines, "\n"))
                  end
                end

                table.insert(chunks, [[
      ; keep merge()/isinstance() args blue
      ((call
        function: (identifier) @_call_fn
        arguments: (argument_list
          (identifier) @variable.parameter))
        (#eq? @_call_fn "merge"))

      ((call
        function: (identifier) @_call_fn
        arguments: (argument_list
          (identifier) @variable.parameter
          (_)))
        (#eq? @_call_fn "isinstance"))

      ((call
        function: (identifier) @_call_fn
        arguments: (argument_list
          (subscript
            value: (identifier) @variable.parameter
            subscript: (identifier) @variable.parameter)))
        (#eq? @_call_fn "merge"))

      ; keep builtins (e.g. ValueError, list) on type.builtin color
      ((call
        function: (identifier) @type.builtin)
        (#any-of? @type.builtin "ValueError" "list" "dict"))

      ((call
        function: (identifier) @_call_fn
        arguments: (argument_list
          (_)
          (identifier) @type.builtin))
        (#eq? @_call_fn "isinstance"))

      ; keep object in class superclasses on builtin type color
      ((class_definition
        superclasses: (argument_list
          (identifier) @type.builtin))
        (#eq? @type.builtin "object"))

      ; force constructor calls (e.g. Merger()) to win over function.call style
      ((call
        function: (identifier) @constructor)
        (#lua-match? @constructor "^%u")
        (#set! priority 130))

      ((call
        function: (attribute
          attribute: (identifier) @constructor))
        (#lua-match? @constructor "^%u")
        (#set! priority 130))

      ; highlight f-string prefix (f/F) like a keyword
      ((string
        (string_start) @string.special)
        (#lua-match? @string.special "^[fF]"))
                ]])

                vim.treesitter.query.set("python", "highlights", table.concat(chunks, "\n\n"))
                vim.g.catppuccin_python_highlight_query_override_version = catppuccin_python_query_override_version
                return true
              end

              if not apply_python_query_overrides() then
                vim.api.nvim_create_autocmd("FileType", {
                  pattern = "python",
                  once = true,
                  callback = function()
                    apply_python_query_overrides()
                  end,
                })
              end

              local catppuccin_python_lsp_group = vim.api.nvim_create_augroup("CatppuccinPythonLsp", { clear = true })
              vim.api.nvim_create_autocmd("LspAttach", {
                group = catppuccin_python_lsp_group,
                callback = function(args)
                  if vim.bo[args.buf].filetype ~= "python" then
                    return
                  end

                  local client_id = args.data and args.data.client_id
                  if not client_id then
                    return
                  end

                  local client = vim.lsp.get_client_by_id(client_id)
                  if not client then
                    return
                  end

                  client.server_capabilities.semanticTokensProvider = nil
                  pcall(vim.lsp.semantic_tokens.stop, args.buf, client.id)
                end,
              })
            end
    '';

    plugins.bufferline.settings.highlights.fill.bg = lib.mkForce "NONE";
    plugins.telescope.highlightTheme = "Catppuccin Mocha";
  };
}
