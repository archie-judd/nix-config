{ config, lib, pkgs, ... }:

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
      hsp = "tmux-hsplit";
      tmux =
        "direnv exec / tmux"; # run tmux from the root directory to avoid issues with direnv
    };
    sessionVariables = {
      EDITOR =
        "nvim"; # homeManager.sessionVariables aren't persisted after re-login
      PROMPT_COMMAND = "history -a;history -c;history -r";
    };
    shellOptions = [ "histappend" "checkwinsize" ];
    profileExtra = "source ~/.bashrc";
    initExtra =

      # if sops is enabled, load the Anthropic API key into the environment
      lib.optionalString (config ? sops) ''
        export ANTHROPIC_API_KEY="$(cat ${config.sops.secrets.anthropic-api-key.path})"
      ''

      # on macOS, load Homebrew environment
      + lib.optionalString pkgs.stdenv.isDarwin ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
  };

}
