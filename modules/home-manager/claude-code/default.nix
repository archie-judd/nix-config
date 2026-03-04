{ config, pkgs, agent-sandbox-nix, claude-code-nix, ... }:
let
  secretPath = config.sops.secrets.claude-code-oauth-token.path;
  claude-code-pkg =
    claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
  claude-sandboxed =
    agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system}.mkSandbox {
      pkg = claude-code-pkg;
      binName = "claude";
      outName = "claude";
      stateDirs = [ "$HOME/.claude" ];
      stateFiles = [ "$HOME/.claude.json" ];
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
        CLAUDE_CODE_OAUTH_TOKEN = "$(${pkgs.coreutils}/bin/cat ${secretPath})";
        GIT_AUTHOR_NAME = "claude-agent";
        GIT_AUTHOR_EMAIL = "claude-agent@localhost";
        GIT_COMMITTER_NAME = "claude-agent";
        GIT_COMMITTER_EMAIL = "claude-agent@localhost";
      };
      inheritPath = true;
    };

in {
  programs.bash.initExtra = ''
    ${builtins.readFile ./scripts/claude-task-completions.sh}
    ${builtins.readFile ./scripts/claude-delegate.sh}
    ${builtins.readFile ./scripts/claude-resume.sh}
    ${builtins.readFile ./scripts/claude-switch.sh}
    ${builtins.readFile ./scripts/claude-delete.sh}
    complete -F _claude_task_completions claude-resume
    complete -F _claude_task_completions claude-switch
    complete -F _claude_task_completions claude-delete
  '';
  home.file = {
    ".claude/prompts/delegate.md" = { source = ./claude/prompts/delegate.md; };
    ".claude/settings.json" = { source = ./claude/settings.json; };
  };
  home.packages = [ claude-sandboxed ];
}
