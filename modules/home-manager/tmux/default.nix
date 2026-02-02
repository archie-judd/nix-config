{ pkgs, ... }:

let
  tmux-vsplit = pkgs.writeShellScriptBin "tmux-vsplit"
    (builtins.readFile ./scripts/tmux-vsplit.sh);
  tmux-hsplit = pkgs.writeShellScriptBin "tmux-hsplit"
    (builtins.readFile ./scripts/tmux-hsplit.sh);
in {
  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "xterm-256color";
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

  home.packages = [ tmux-vsplit tmux-hsplit ];
}
