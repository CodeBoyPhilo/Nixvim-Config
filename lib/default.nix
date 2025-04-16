{ pkgs, ... }:
{
  mkPkgs = name: src: pkgs.vimUtils.buildVimPlugin { inherit name src; };
}
