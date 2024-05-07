{ config, pkgs, lib, ... }:

{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--extended"
      "--color='bg+:-1,fg+:-1,fg:#AEACAA,fg+:#FFFBF6'"
    ];
    defaultCommand = null;
    changeDirWidgetCommand = "fd . $HOME --type d";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    fileWidgetCommand = "fd --type file --hidden --follow --exclude .git";
  };
  home.packages = [ pkgs.tree ];
}
