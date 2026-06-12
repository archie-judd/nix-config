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
  claude-refresh-creds = pkgs.writeShellApplication {
    name = "claude-refresh-credentials";
    runtimeInputs = [
      pkgs.jq
      pkgs.coreutils
      pkgs.gnugrep
    ];
    text = builtins.readFile ./refresh-credentials.sh;
  };
  agent-sandbox = inputs.agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system};
  claude-sandboxed = agent-sandbox.mkSandbox {
    pkg = pkgs.claude-code;
    binName = "claude";
    outName = "claude-sandboxed";
    allowedPackages = agent-sandbox.commonTools ++ [
      neovim
    ];
    rwDirs = [ claude_config_dir ];
    env = {
      EDITOR = "nvim";
      COLORTERM = "truecolor";
      CLAUDE_CONFIG_DIR = "$CLAUDE_CONFIG_DIR";
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
in
{
  home.packages = [
    claude-sandboxed
    pkgs.claude-code
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [ claude-refresh-creds ];
  home.sessionVariables.CLAUDE_CONFIG_DIR = claude_config_dir;

  # write the file - don't symlink it -D means create parent directories, -m644 sets permissions (rw- for owner, r-- for group and others)
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run install -Dm644 ${./claude/settings.json} "${config.home.homeDirectory}/.claude/settings.json"
  '';
  home.activation.claudeMd = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run install -Dm644 ${./claude/CLAUDE.md} "${config.home.homeDirectory}/.claude/CLAUDE.md"
  '';

  programs.bash.initExtra = ''
    qq() { local msg="$1"; shift; claude --model sonnet "$@" -p "$msg"; }
  '';
}
