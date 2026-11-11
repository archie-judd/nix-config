{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  isWork,
  ...
}:
let
  neovim = inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim-minimal;
  claude_config_dir = "$HOME/.claude";
  agent-sandbox = inputs.agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system};
  readSecret = name: "$(${pkgs.coreutils}/bin/cat $SOPS_DECRYPTED_DIR/${name})";
  accounts = {
    work = {
      claudeSecretName = "claude-code-oauth-token-work";
      githubSecretName = "github-pat-work";
    };
    personal = {
      claudeSecretName = "claude-code-oauth-token-personal";
      githubSecretName = "github-read-token-personal";
    };
  };
  defaultAccount = if isWork then accounts.work else accounts.personal;
  configDirNames = [ ".claude" ] ++ lib.optional isWork ".claude-personal";
  mkClaudeSandbox =
    {
      outName,
      configDir,
      claudeSecretName,
      githubSecretName,
    }:
    agent-sandbox.mkSandbox {
      pkg = pkgs-unstable.claude-code;
      binName = "claude";
      outName = outName;
      allowedPackages = agent-sandbox.commonTools ++ [
        neovim
        pkgs.gh
        pkgs.curl
        (pkgs.python3.withPackages (ps: with ps; [ pymupdf4llm ]))
        pkgs.poppler
      ];
      rwDirs = [ configDir ];
      roFiles = [ "$HOME/.config/git/config" ];
      env = {
        EDITOR = "nvim";
        COLORTERM = "truecolor";
        CLAUDE_CONFIG_DIR = configDir;
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
  claude-sandboxed = mkClaudeSandbox (
    defaultAccount
    // {
      outName = "claude-sandboxed";
      configDir = claude_config_dir;
    }
  );
  claude-sandboxed-personal = mkClaudeSandbox (
    accounts.personal
    // {
      outName = "claude-sandboxed-personal";
      configDir = "$HOME/.claude-personal";
    }
  );
in
{
  home.packages = [
    pkgs-unstable.claude-code
    claude-sandboxed
  ]
  ++ lib.optional isWork claude-sandboxed-personal;
  home.sessionVariables.CLAUDE_CONFIG_DIR = claude_config_dir;

  # write the file - don't symlink it, so claude can edit it if needed
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatMapStringsSep "\n" (dir: ''
      run install -Dm644 ${./claude/settings.json} "${config.home.homeDirectory}/${dir}/settings.json"
    '') configDirNames
  );
  # readonly, so symlink is fine
  home.file = lib.listToAttrs (
    lib.concatMap (dir: [
      {
        name = "${dir}/CLAUDE.md";
        value.source = ./claude/CLAUDE.md;
      }
      {
        name = "${dir}/output-styles/terse.md";
        value.source = ./claude/output-styles/terse.md;
      }
    ]) configDirNames
  );
  programs.bash.initExtra = ''
    qq() { local msg="$1"; shift; claude-sandboxed --model sonnet "$@" -p "$msg"; }
  '';
}
