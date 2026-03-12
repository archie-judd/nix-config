{ config, pkgs, pkgs-unstable, agent-sandbox-nix, ... }:
let
  secretPath = config.sops.secrets.github-token.path;
  copilot-sandboxed =
    agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system}.mkSandbox {
      pkg = pkgs-unstable.github-copilot-cli;
      binName = "copilot";
      outName = "copilot-sandboxed";
      allowedPackages = [
        pkgs.coreutils
        pkgs.which
        pkgs.bash
        pkgs.git
        pkgs.ripgrep
        pkgs.fd
        pkgs.gnused
        pkgs.gnugrep
        pkgs.findutils
        pkgs.jq
      ];
      stateDirs = [ "$HOME/.config/github-copilot" "$HOME/.copilot" ];
      stateFiles = [ ];
      extraEnv = {
        CLAUDE_CODE_OAUTH_TOKEN = "$(${pkgs.coreutils}/bin/cat ${secretPath})";
        GIT_AUTHOR_NAME = "copilot-agent";
        GIT_AUTHOR_EMAIL = "copilot-agent@localhost";
        GIT_COMMITTER_NAME = "copilot-agent";
        GIT_COMMITTER_EMAIL = "copilot-agent@localhost";
      };
    };

in {
  home.packages = [ copilot-sandboxed ];
  home.file = {
    ".copilot/agents" = { source = ./copilot/agents; };
    ".copilot/hooks" = { source = ./copilot/hooks; };
  };
  programs.bash.shellAliases = {
    copilot-delegate = "copilot --agent delegate --yolo";
    copilot-resume = "copilot --agent delegate --yolo --continue";
  };
}
