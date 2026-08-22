{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  extraConfigLuaPre = ''
    vim.env.VIMTEX_CACHE_ROOT = vim.env.VIMTEX_CACHE_ROOT
      or (vim.fn.stdpath("cache") .. "/vimtex/" .. vim.fn.getpid())
    vim.g.vimtex_cache_root = vim.env.VIMTEX_CACHE_ROOT
  '';

  plugins.vimtex = {
    enable = true;
    texlivePackage = pkgs.texlive.combined.scheme-full;
    settings = {
      view_method = if isDarwin then "skim" else "zathura";
      compiler_latexmk = {
        aux_dir = "./aux";
        out_dir = "./out";
        callback = 1;
        continuous = 1;
        executable = "latexmk";
        options = [
          "-verbose"
          "-file-line-error"
          "-synctex=1"
          "-interaction=nonstopmode"
        ];
      };
    };
  };
}
