{
  config,
  pkgs,
  lib,
  ...
}:
{
  extraPlugins = [
    pkgs.vimPlugins.vim-tpipeline
    pkgs.vimPlugins.luasnip
    pkgs.vimPlugins.minimap-vim
    pkgs.vimPlugins.leetcode-nvim
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-silicon";
      src = pkgs.fetchFromGitHub {
        owner = "michaelrommel";
        repo = "nvim-silicon";
        rev = "7f66bda8f60c97a5bf4b37e5b8acb0e829ae3c32";
        hash = "sha256-XiYn/L2e/B+6LTjak3jAwRgnZ3gCbsyA0J61Dd+jZv4=";
      };
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "neovim-tips";
      src = pkgs.fetchFromGitHub {
        owner = "saxon1964";
        repo = "neovim-tips";
        rev = "ec50d3c5eccb120c58719da1ef15787dcba40a1a";
        hash = "sha256-uGE3Pdf8XxrLLl0/S1r/1Eqv5sdjD5iwAAmvMDyKIuc=";
      };
      dependencies = [
        pkgs.vimPlugins.nui-nvim
      ];
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "transfer";
      src = pkgs.fetchFromGitHub {
        owner = "coffebar";
        repo = "transfer.nvim";
        rev = "af75ad55d621caee1f58fd02ce4e413ad925d948";
        hash = "sha256-UxdNg5+yOP+YaxxFP1PDjJ/G+6tjNYCNw9+HPmmXMzg=";
      };
    })
  ];

  extraConfigLua = ''
                local wk = require("which-key")

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

                ---------- minimap ----------
                vim.g.minimap_width = 10
                vim.g.minimap_highlight_search = 1
                vim.g.minimap_git_colors = 1
            		vim.g.minimap_auto_start = 0

                ---------- luasnip ----------
                local ls = require("luasnip")
                local s = ls.snippet
                local t = ls.text_node
                local i = ls.insert_node

                ls.add_snippets("toml", {
                s("pyright", {
                	t({
                	"[tool.pyright]",
                	"reportAttributeAccessIssue = false",
                	"reportGeneralTypeIssues = false",
                	})
                }),
                })

            		require("leetcode").setup({
            			lang = "python",
            		})

                ---------- nvim-silibon ----------
                require("nvim-silicon").setup({
                font         = "Maple Mono NF CN",
                no_round_corner = true,
                theme        = "Tokyonight Storm",
                background   = nil,
                pad_horiz = 0,
                pad_vert = 0,
                shadow_blur_radius = 0,
                shadow_offset_x = 0,
                shadow_offset_y = 0,
                shadow_color = nil,
                no_line_number = true;
                to_clipboard = true,
                window_title = function()
                	return vim.fn.fnamemodify(
                		vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
                		":t"
                	)
                end,
                output = function()
                	return "~/Pictures/Screenshots/"
                		.. os.date("%Y-%m-%d at %H-%M-%S")
                		.. "_code.png"
                end,
                })

                wk.add({
                	mode = { "v" },
                	{ "<leader>s",  group = "Silicon" },
                	{ "<leader>sc", function() require("nvim-silicon").clip() end, desc = "Copy code screenshot to clipboard" },
                	{ "<leader>sf", function() require("nvim-silicon").file() end,  desc = "Save code screenshot as file" },
                	{ "<leader>ss", function() require("nvim-silicon").shoot() end,  desc = "Create code screenshot" },
                })

                ---------- nvim-tips----------
        				require("neovim_tips").setup({
        				daily_tip = 1
        				})
                
    						---------- transfer ----------
    						require("transfer").setup({})
        				
  '';

  keymaps = [
    {
      key = "<leader>tm";
      action = "<cmd>MinimapToggle<CR>";
      mode = "n";
      options.desc = "Toggle Minimap";
    }
    {
      key = "<leader>nto";
      action = "<cmd>NeovimTips<CR>";
      mode = "n";
      options.desc = "Neovim Tips";
    }
    {
      key = "<leader>nth";
      action = "<cmd>help neovim-tips<CR>";
      mode = "n";
      options.desc = "Neovim Tips Help";
    }
    {
      key = "<leader>ntp";
      action = "<cmd>NeovimTipsPdf<CR>";
      mode = "n";
      options.desc = "Open Neovim Tips PDF";
    }
    {
      mode = "n";
      key = "<leader>ud";
      action = "<cmd>TransferDownload<cr>";
      options = {
        desc = "Download from remote server (scp)";
      };
    }
    {
      mode = "n";
      key = "<leader>uf";
      action = "<cmd>DiffRemote<cr>";
      options = {
        desc = "Diff file with remote server (scp)";
      };
    }
    {
      mode = "n";
      key = "<leader>ui";
      action = "<cmd>TransferInit<cr>";
      options = {
        desc = "Init/Edit Deployment config";
      };
    }
    {
      mode = "n";
      key = "<leader>ur";
      action = "<cmd>TransferRepeat<cr>";
      options = {
        desc = "Repeat transfer command";
      };
    }
    {
      mode = "n";
      key = "<leader>uu";
      action = "<cmd>TransferUpload<cr>";
      options = {
        desc = "Upload to remote server (scp)";
      };
    }
  ];

}
