{
  imports = [
    ./ui/catppuccin.nix

    ./editor/lsp.nix
    ./editor/conform.nix
    ./editor/blink.nix
    ./editor/auto-close.nix
    ./editor/treesitter

    ./tools/snacks
    ./tools/comment.nix
    ./tools/gitsigns.nix
  ];
}
