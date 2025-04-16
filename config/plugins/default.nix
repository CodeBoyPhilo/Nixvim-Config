{
  imports = [
    ./ui/catppuccin.nix
    ./ui/bufferline.nix
    ./ui/dropbar.nix
    ./ui/lualine.nix
    ./ui/noice.nix
    ./ui/notify.nix

    ./editor/lsp.nix
    ./editor/conform.nix
    ./editor/blink.nix
    ./editor/auto-close.nix
    ./editor/treesitter

    ./tools/snacks
    ./tools/comment.nix
    ./tools/gitsigns.nix
    ./tools/lazy.nix
    ./tools/leap.nix
    ./tools/navigator.nix
    ./tools/neotree.nix
    ./tools/telescope.nix
    ./tools/trouble.nix
    ./tools/which-key.nix
  ];
}
