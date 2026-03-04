{ config, pkgs, pkgs-unstable, agent-sandbox-nix, ... }:
let
  secretPath = config.sops.secrets.github-token.path;
  copilot-sandboxed =
    agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system}.mkSandbox {
      pkg = pkgs-unstable.github-copilot-cli;
      binName = "copilot";
      outName = "copilot";
      stateDirs = [ "$HOME/.config/github-copilot" "$HOME/.copilot" ];
      stateFiles = [ ];
      allowedPackages = [
        pkgs.coreutils
        pkgs.bash
        pkgs.git
        pkgs.ripgrep
        pkgs.fd
        pkgs.gnused
        pkgs.gnugrep
        pkgs.findutils
        pkgs.jq
      ];
      extraEnv = {
        GITHUB_TOKEN = "$(${pkgs.coreutils}/bin/cat ${secretPath})";
        GIT_AUTHOR_NAME = "copilot-agent";
        GIT_AUTHOR_EMAIL = "copilot-agent@localhost";
        GIT_COMMITTER_NAME = "copilot-agent";
        GIT_COMMITTER_EMAIL = "copilot-agent@localhost";
      };
      inheritPath = true;
    };

in {
  programs.bash.initExtra = ''
    ${builtins.readFile ./scripts/copilot-task-completions.sh}
    ${builtins.readFile ./scripts/copilot-delegate.sh}
    ${builtins.readFile ./scripts/copilot-resume.sh}
    ${builtins.readFile ./scripts/copilot-switch.sh}
    ${builtins.readFile ./scripts/copilot-delete.sh}
    complete -F _copilot_task_completions copilot-resume
    complete -F _copilot_task_completions copilot-switch
    complete -F _copilot_task_completions copilot-delete
  '';
  home.file = {
    ".copilot/agents" = { source = ./copilot/agents; };
    ".copilot/hooks" = { source = ./copilot/hooks; };
  };
  home.packages = [ copilot-sandboxed ];
}
