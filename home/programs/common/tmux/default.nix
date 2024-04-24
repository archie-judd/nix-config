{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "xterm-256color";
    escapeTime = 30;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.yank;
        extraConfig = builtins.readFile ./tmux-yank.conf;
      }
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = builtins.readFile ./tmux-catppuccin.conf;
      }
    ];
    extraConfig = builtins.readFile ./tmux-extra.conf;
  };
}
