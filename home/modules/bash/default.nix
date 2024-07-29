{ ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignorespace" "erasedups" ];
    historyFileSize = 10000;
    historySize = 10000;
    shellAliases = {
      ls = "eza";
      reload = ''exec "$SHELL"'';
      vsp = "tmux_vsplit";
      hsp = "tmux_hsplit";
      gsp = "cd $HOME/repos/gridshare-planning";
      gs = "cd $HOME/repos/gridshare-edge";
      nc = "cd $HOME/.config/nix";
    };
    sessionVariables = { PROMPT_COMMAND = "history -a;history -c;history -r"; };
    shellOptions = [ "histappend" "checkwinsize" ];
    initExtra = ''
      source ${./functions.sh}
    '';
  };

}

