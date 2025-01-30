{ lib, pkgs, ... }:

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
      gsp = "cd $HOME/workspaces/gridshare-planning";
      gs = "cd $HOME/workspaces/gridshare-edge";
      nc = "cd $HOME/workspaces/nix-config";
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      fkill = "ps | fzf | awk '{print $1}' | xargs kill -9";
    };
    sessionVariables = {
      PROMPT_COMMAND = "history -a;history -c;history -r";
    } // lib.attrsets.optionalAttrs pkgs.stdenv.isLinux {
      SHELL = "${pkgs.bashInteractive}/bin/bash";
    }; # Force shell for nix-darwin
    shellOptions = [ "histappend" "checkwinsize" ];
    initExtra = ''
      source ${pkgs.git}/share/bash-completion/completions/git
      source ${./functions.sh}
    '';
    profileExtra = "source ~/.bashrc";
  };

}

