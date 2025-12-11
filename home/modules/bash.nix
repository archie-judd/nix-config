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
      vsp = "tmux-vsplit";
      hsp = "tmux=hsplit";
      vi = "nvim";
      vim = "nvim";
      tmux =
        "direnv exec / tmux"; # run tmux from the root directory to avoid issues with direnv
      "??" = "copilot -p";
    };
    sessionVariables = {
      EDITOR =
        "nvim"; # homeManager.sessionVariables aren't persisted after re-login
      PROMPT_COMMAND = "history -a;history -c;history -r";
    };
    shellOptions = [ "histappend" "checkwinsize" ];
    profileExtra = "source ~/.bashrc";
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)" 
      	''; # Add homebrew to path
  };

}

