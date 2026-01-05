{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = false;
    vimAlias = false;
    plugins = [ pkgs.vimPlugins.tmux-nvim ];
  };

  home.file.".config/nvim/init.lua" = {
    source = ./init.lua;
    recursive = false;
  };
}
