{
  imports = [
    ./ui/catppuccin.nix
    ./ui/bufferline.nix
    ./ui/dashboard.nix
    ./ui/dropbar.nix
    ./ui/lualine.nix
    ./ui/noice.nix
    ./ui/notify.nix
    ./ui/nui.nix
    ./ui/tagbar.nix
    ./ui/tokyonight.nix
    ./ui/ufo.nix
    ./ui/web-devicons.nix

    ./editor/lsp.nix
    ./editor/conform.nix
    ./editor/blink.nix
    ./editor/auto-close.nix
    ./editor/treesitter

    ./tools/snacks
    ./tools/comment.nix
    ./tools/dap.nix
    ./tools/gitsigns.nix
    ./tools/highlight-colors.nix
    ./tools/lazy.nix
    ./tools/leap.nix
    ./tools/mini.nix
    ./tools/navigator.nix
    ./tools/neotree.nix
		./tools/render-markdown.nix
    ./tools/telescope.nix
    ./tools/trouble.nix
		./tools/vimtex.nix
		./tools/wakatime.nix
    ./tools/which-key.nix
		./tools/yazi.nix

    ./extras/extras.nix
  ];
}
