{ lib, config, pkgs, pkgs-unstable, inputs, ... }:
let
  neovim =
    inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim-minimal;
  claude_config_dir = "$HOME/.claude";
  claude-sandboxed =
    inputs.agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system}.mkSandbox {
      pkg = pkgs.claude-code;
      binName = "claude";
      outName = "claude-sandboxed";
      allowedPackages = [
        pkgs.coreutils
        pkgs.which
        pkgs.git
        pkgs.less
        pkgs.ripgrep
        pkgs.fd
        pkgs.gnused
        pkgs.gnugrep
        pkgs.findutils
        pkgs.jq
        neovim
      ];
      stateDirs = [ claude_config_dir ];
      extraEnv = {
        EDITOR = "nvim";
        COLORTERM = "truecolor";
        CLAUDE_CONFIG_DIR = "$CLAUDE_CONFIG_DIR";
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
  home.sessionVariables.CLAUDE_CONFIG_DIR = claude_config_dir;
  home.file = {
    ".claude/settings.json" = { source = ./claude/settings.json; };
  };
  programs.bash.initExtra = ''
    qq() { local msg="$1"; shift; claude --model sonnet "$@" -p "$msg"; }
  '';
}
