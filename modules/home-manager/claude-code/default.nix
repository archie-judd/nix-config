{ lib, config, pkgs, pkgs-unstable, inputs, ... }:
let
  neovim =
    inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim-minimal;
  claude-sandboxed =
    inputs.agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system}.mkSandbox {
      pkg = pkgs.claude-code;
      binName = "claude";
      outName = "claude-sandboxed";
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
        EDITOR = "nvim";
      } // lib.optionalAttrs pkgs.stdenv.isDarwin {
        CLAUDE_CODE_OAUTH_TOKEN =
          "$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.claude-code-oauth-token.path})";
      };
      restrictNetwork = true;
      allowedDomains = {
        "anthropic.com" = "*";
        "claude.com" = "*";
        "github.com" = "*";
        "githubusercontent.com" = [ "GET" "HEAD" ];
      };

    };
in {
  home.packages = [ claude-sandboxed pkgs.claude-code ];
  home.file = {
    ".claude/settings.json" = { source = ./claude/settings.json; };
  };
  programs.bash.initExtra = ''
    qq() { local msg="$1"; shift; claude --model sonnet "$@" -p "$msg"; }
  '';
}
