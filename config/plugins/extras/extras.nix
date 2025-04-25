{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Add the plugins via extraPlugins
  # extraPlugins = with pkgs.vimPlugins; [
  #   vim-tpipeline
  #
  #   # mannually configure luasnip, since adding custom snippets are problematic in nixvim due to path issues.
  #   # https://github.com/nix-community/nixvim/discussions/2162
  #   luasnip
  # ];
  extraPlugins = [
    pkgs.vimPlugins.vim-tpipeline
    pkgs.vimPlugins.luasnip
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-silicon";
      src = pkgs.fetchFromGitHub {
        owner = "michaelrommel";
        repo = "nvim-silicon";
        rev = "7f66bda8f60c97a5bf4b37e5b8acb0e829ae3c32";
        hash = "sha256-XiYn/L2e/B+6LTjak3jAwRgnZ3gCbsyA0J61Dd+jZv4=";
      };
    })
  ];

  extraConfigLua = ''
    		---------- tpipeline ----------
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

    		---------- luasnip ----------
    		local ls = require("luasnip")
    		local s = ls.snippet
    		local t = ls.text_node
    		local i = ls.insert_node

    		-- Define custom snippets
    		ls.add_snippets("toml", {
    			s("pyright", {
    				t({
    				"[tool.pyright]",
    				"reportAttributeAccessIssue = false",
    				"reportGeneralTypeIssues = false",
    				})
    			}),
    		})

    		---------- nvim-silibon ----------
    		require("nvim-silicon").setup({
    			font         = "Maple Mono NF CN",
    			no_round_corner = true,
    			theme        = "Tokyonight Night",
    			background   = nil,
    			pad_horiz = 0,
    			pad_vert = 0,
    			shadow_blur_radius = 0,
    			shadow_offset_x = 0,
    			shadow_offset_y = 0,
    			shadow_color = nil,
    			-- line_offset = function(args)
    			-- 		return args.line1
    			-- end,        							
    			no_line_number = true;
    			to_clipboard = true,
    			window_title = function()
    				return vim.fn.fnamemodify(
    					vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
    					":t"
    				)
    			end,
    			output = function()
    				return "/Users/phil_oh/Desktop/screenshot/"
    					.. os.date("%Y-%m-%d at %H-%M-%S")
    					.. "_code.png"
    			end,
    		})

    		local wk = require("which-key")
    		wk.add({
    				mode = { "v" },
    				{ "<leader>s",  group = "Silicon" },
    				{ "<leader>sc", function() require("nvim-silicon").clip() end, desc = "Copy code screenshot to clipboard" },
    				{ "<leader>sf", function() require("nvim-silicon").file() end,  desc = "Save code screenshot as file" },
    				{ "<leader>ss", function() require("nvim-silicon").shoot() end,  desc = "Create code screenshot" },
    		})

  '';
}
