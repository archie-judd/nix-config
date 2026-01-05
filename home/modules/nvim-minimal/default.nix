{ lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = false;
    vimAlias = false;
  };

  home.file.".config/nvim/init.lua" = {
    source = ./init.lua;
    recursive = false;
  };
}
