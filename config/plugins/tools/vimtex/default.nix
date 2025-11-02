{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
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
