{ config, pkgs, pkgs-unstable, inputs, ... }:
let
  claude-code-oath-token-path =
    config.sops.secrets.claude-code-oauth-token.path;
  github-read-token-path = config.sops.secrets.github-read-token.path;
  neovim =
    inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim-minimal;
  claude-sandboxed =
    inputs.agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system}.mkSandbox {
      pkg = pkgs-unstable.claude-code;
      binName = "claude";
      outName = "claude";
      allowedPackages = [
        pkgs.coreutils
        pkgs.which
        pkgs.bashNonInteractive
        pkgs.git
        pkgs.ripgrep
        pkgs.fd
        pkgs.gnused
        pkgs.gnugrep
        pkgs.findutils
        pkgs.jq
        neovim
      ];
      stateDirs = [ "$HOME/.claude" ];
      stateFiles = [ "$HOME/.claude.json" "$HOME/.claude.json.lock" ];
      extraEnv = {
        CLAUDE_CODE_OAUTH_TOKEN =
          "$(${pkgs.coreutils}/bin/cat ${claude-code-oath-token-path})";
        GITHUB_TOKEN = "$(${pkgs.coreutils}/bin/cat ${github-read-token-path})";
        EDITOR = "nvim";
        GIT_AUTHOR_NAME = "claude-agent";
        GIT_AUTHOR_EMAIL = "claude-agent@localhost";
        GIT_COMMITTER_NAME = "claude-agent";
        GIT_COMMITTER_EMAIL = "claude-agent@localhost";
      };
    };
in {
  home.packages = [ claude-sandboxed ];
  home.file = {
    ".claude/settings.json" = { source = ./claude/settings.json; };
  };
  programs.bash.initExtra = ''
    qq() { local msg="$1"; shift; claude --model sonnet "$@" -p "$msg"; }
  '';
}
