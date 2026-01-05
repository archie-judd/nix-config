{ lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true; # Sets $EDITOR to nvim
    viAlias = false; # Aliases vi -> nvim
    vimAlias = false; # Aliases vim -> nvim
  };

  home.file.".config/nvim/init.lua" = {
    source = ./init.lua;
    recursive = false;
  };
}
