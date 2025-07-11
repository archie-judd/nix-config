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
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      fkill = "ps | fzf | awk '{print $1}' | xargs kill -9";
      tmux =
        "direnv exec / tmux"; # run tmux from the root directory to avoid issues with direnv
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
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    initExtra = ''
      source ${pkgs.git}/share/bash-completion/completions/git
      source ${./functions.sh}
      eval "$(/opt/homebrew/bin/brew shellenv)" 
      	''; # Add homebrew to path
  };

}

