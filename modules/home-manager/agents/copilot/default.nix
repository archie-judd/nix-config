{ lib, pkgs, pkgs-unstable, ... }:
let
  sandbox = import ../sandbox.nix { pkgs = pkgs; };
  copilot-sandboxed = sandbox.mkLinuxSandbox {
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
      GIT_AUTHOR_NAME = "copilot-agent";
      GIT_AUTHOR_EMAIL = "copilot-agent@localhost";
      GIT_COMMITTER_NAME = "copilot-agent";
      GIT_COMMITTER_EMAIL = "copilot-agent@localhost";
    };
  };

in lib.mkMerge [
  {
    programs.bash.initExtra = ''
      ${builtins.readFile ./scripts/copilot-task-completions.sh}
      ${builtins.readFile ./scripts/copilot-switch.sh}
      ${builtins.readFile ./scripts/copilot-delete.sh}
      ${builtins.readFile ./scripts/copilot-delegate.sh}
      complete -F _copilot_task_completions copilot-switch
      complete -F _copilot_task_completions copilot-delete
    '';
    home.file.".copilot/agents" = { source = ./copilot/agents; };
    home.file.".copilot/hooks" = { source = ./copilot/hooks; };
  }
  (lib.mkIf pkgs.stdenv.isLinux { home.packages = [ copilot-sandboxed ]; })
  (lib.mkIf pkgs.stdenv.isDarwin { home.packages = [ pkgs-unstable.copilot ]; })
]
