{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "tmux-256color";
    escapeTime = 30;
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.yank;
        extraConfig = builtins.readFile ./configuration/tmux-yank.conf;
      }
      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = builtins.readFile ./configuration/tmux-catppuccin.conf;
      }

      { plugin = pkgs.tmuxPlugins.open; }
    ];
    extraConfig = builtins.readFile ./configuration/tmux-extra.conf;
  };
}
