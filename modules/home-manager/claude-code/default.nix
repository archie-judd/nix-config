{
  lib,
  config,
  pkgs,
  inputs,
  isPersonal,
  ...
}:
let
  neovim = inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim-minimal;
  claude_config_dir = "$HOME/.claude";
  agent-sandbox = inputs.agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system};
  readSecret = name: "$(${pkgs.coreutils}/bin/cat $SOPS_DECRYPTED_DIR/${name})";
  claudeSecretName =
    if isPersonal then "claude-code-oauth-token-personal" else "claude-code-oauth-token-work";
  githubSecretName = if isPersonal then "github-read-token-personal" else "github-pat-work";
  claude-sandboxed = agent-sandbox.mkSandbox {
    pkg = pkgs.claude-code;
    binName = "claude";
    outName = "claude-sandboxed";
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
    };
    injectedCredentials = {
      GH_TOKEN = {
        secret = readSecret githubSecretName;
        placeholder = "dummy";
        hosts."api.githubcopilot.com" = {
          scheme = "bearer";
        };
      };
      CLAUDE_CODE_OAUTH_TOKEN = {
        secret = readSecret claudeSecretName;
        placeholder = "sk-ant-oat01-dummy";
        hosts."api.anthropic.com" = {
          scheme = "bearer";
        };
      };
    };
    allowedDomains = {
      "anthropic.com" = "*";
      "claude.com" = "*";
      "api.githubcopilot.com/mcp/readonly" = [
        "GET"
        "POST"
      ];
      "githubusercontent.com" = [
        "GET"
        "HEAD"
      ];
    };
  };
in
{
  home.packages = [
    pkgs.claude-code
    claude-sandboxed

  ];
  home.sessionVariables.CLAUDE_CONFIG_DIR = claude_config_dir;

  # write the file - don't symlink it, so claude can edit it if needed
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run install -Dm644 ${./claude/settings.json} "${config.home.homeDirectory}/.claude/settings.json"
  '';
  # readonly, so symlink is fine
  home.file = {
    ".claude/CLAUDE.md".source = ./claude/CLAUDE.md;
    ".claude/output-styles/terse.md".source = ./claude/output-styles/terse.md;
    ".claude/skills/asd-ste100/SKILL.md".source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/danyuchn/asd-ste100-skill/master/SKILL.md";
      sha256 = "sha256:134lpbaid62y3svn6r8ni7rfbmf9aqhv6phn2jkwlr212wjc2zyl";
    };
  };
  programs.bash.initExtra = ''
    qq() { local msg="$1"; shift; claude-sandboxed --model sonnet "$@" -p "$msg"; }
  '';
}
