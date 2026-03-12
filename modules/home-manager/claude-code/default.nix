{ config, pkgs, pkgs-unstable, agent-sandbox-nix, ... }:
let
  secretPath = config.sops.secrets.claude-code-oauth-token.path;
  claude-sandboxed =
    agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system}.mkSandbox {
      pkg = pkgs-unstable.claude-code;
      binName = "claude";
      outName = "claude";
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
      stateDirs = [ "$HOME/.claude" ];
      stateFiles = [ "$HOME/.claude.json" "$HOME/.claude.json.lock" ];
      extraEnv = {
        CLAUDE_CODE_OAUTH_TOKEN = "$(${pkgs.coreutils}/bin/cat ${secretPath})";
        GIT_AUTHOR_NAME = "claude-agent";
        GIT_AUTHOR_EMAIL = "claude-agent@localhost";
        GIT_COMMITTER_NAME = "claude-agent";
        GIT_COMMITTER_EMAIL = "claude-agent@localhost";
      };
    };
in {
  home.packages = [ claude-sandboxed ];
  home.file = {
    ".claude/prompts/delegate.md" = { source = ./claude/prompts/delegate.md; };
    ".claude/settings.json" = { source = ./claude/settings.json; };
  };
  programs.bash.shellAliases = {
    claude-delegate = ''
      claude --append-system-prompt-file "$HOME/.claude/prompts/delegate.md" --dangerously-skip-permissions'';
    claude-resume = ''
      claude --continue --append-system-prompt-file "$HOME/.claude/prompts/delegate.md" --dangerously-skip-permissions'';

  };
  programs.bash.initExtra = ''
    qq() { claude --model sonnet -p "$*"; }
    qqc() { claude --model sonnet -p "$*" --continue; }
  '';
}
