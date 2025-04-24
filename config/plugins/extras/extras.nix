{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Add the plugins via extraPlugins
  extraPlugins = with pkgs.vimPlugins; [
    vim-tpipeline

    # mannually configure luasnip, since adding custom snippets are problematic in nixvim due to path issues.
    # https://github.com/nix-community/nixvim/discussions/2162
    luasnip
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
  '';
}
