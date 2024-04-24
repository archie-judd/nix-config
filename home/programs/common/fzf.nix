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
    defaultCommand = "fdfind --type file --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fdfind --hidden";
    fileWidgetCommand = "fdfind --type file --hidden --follow --exclude .git";
  };
}
