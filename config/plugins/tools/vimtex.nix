{ pkgs, ... }:
{
  plugins.vimtex = {
    enable = true;
    texlivePackage = pkgs.texlive.combined.scheme-full;
    settings = {
		  # view_method = "zathura";
			view_general_viewer = "okular";
			view_general_options = "--unique file:@pdf\#src:@line@tex";
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
