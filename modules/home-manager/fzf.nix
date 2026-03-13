{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--extended"
      "--color='bg+:-1,fg+:-1,fg:#AEACAA,fg+:#FFFBF6'"
    ];
  };
  home.packages = [ pkgs.tree ];
  programs.bash.initExtra = ''
    export FZF_ALT_C_COMMAND="fd --type d"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
    export FZF_CTRL_T_COMMAND="fd --type file --hidden --follow --exclude .git"
  '';
}
