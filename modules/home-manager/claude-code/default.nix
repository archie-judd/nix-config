{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
let
  neovim = inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim-minimal;
  claude_config_dir = "$HOME/.claude";
  agent-sandbox = inputs.agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system};
  mkClaudeSandbox =
    pkg: binName: outName:
    agent-sandbox.mkSandbox {
      pkg = pkg;
      binName = binName;
      outName = outName;
      allowedPackages = agent-sandbox.commonTools ++ [
        neovim
        pkgs.gh
        pkgs.curl
        pkgs.python3
      ];
      rwDirs = [ claude_config_dir ];
      roFiles = [ "$HOME/.config/git/config" ];
      env = {
        EDITOR = "nvim";
        COLORTERM = "truecolor";
        CLAUDE_CONFIG_DIR = claude_config_dir;
        GH_TOKEN = "$(${pkgs.coreutils}/bin/cat $SOPS_DECRYPTED_DIR/github-read-token)";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        CLAUDE_CODE_OAUTH_TOKEN = "$(${pkgs.coreutils}/bin/cat $SOPS_DECRYPTED_DIR/claude-code-oauth-token)";
      };
      allowedDomains = {
        "anthropic.com" = "*";
        "claude.com" = "*";
        "github.com" = "*";
        "githubusercontent.com" = [
          "GET"
          "HEAD"
        ];
      };
    };
  claude-sandboxed = mkClaudeSandbox pkgs.claude-code "claude" "claude-sandboxed";
  claude-agent-acp-sandboxed =
    mkClaudeSandbox pkgs.claude-agent-acp "claude-agent-acp"
      "claude-agent-acp";
in
{
  home.packages = [
    pkgs.claude-code
    claude-sandboxed
    claude-agent-acp-sandboxed

  ];
  home.sessionVariables.CLAUDE_CONFIG_DIR = claude_config_dir;

  # write the file - don't symlink it, so claude can edit it if needed
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run install -Dm644 ${./claude/settings.json} "${config.home.homeDirectory}/.claude/settings.json"
  '';
  # readonly, so symlink is fine
  home.file = {
    ".claude/CLAUDE.md".source = ./claude/CLAUDE.md;
    ".claude/output-styles/prose-conventions.md".source = ./claude/output-styles/prose-conventions.md;
    ".claude/skills/asd-ste100/SKILL.md".source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/danyuchn/asd-ste100-skill/master/SKILL.md";
      sha256 = "sha256:134lpbaid62y3svn6r8ni7rfbmf9aqhv6phn2jkwlr212wjc2zyl";
    };
  };
  programs.bash.initExtra = ''
    qq() { local msg="$1"; shift; claude-sandboxed --model sonnet "$@" -p "$msg"; }
  '';
}
