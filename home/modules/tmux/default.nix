{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "xterm-256color";
    escapeTime = 30;
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.yank;
        extraConfig = builtins.readFile ./tmux-yank.conf;
      }
      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = builtins.readFile ./tmux-catppuccin.conf;
      }
    ];
    extraConfig = builtins.readFile ./tmux-extra.conf;
  };
}
