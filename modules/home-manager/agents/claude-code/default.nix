{ lib, config, pkgs, claude-code-nix, ... }:
let
  secretPath = config.sops.secrets.claude-code-oauth-token.path;
  sandbox = import ../sandbox.nix { pkgs = pkgs; };
  claude-code-pkg =
    claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # We need to wrap the claude-code binaries to set the CLAUDE_CODE_OAUTH_TOKEN 
  # environment variable from the secret file.
  claude-code-authed = claude-code-pkg.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/claude \
        --run 'export CLAUDE_CODE_OAUTH_TOKEN="$(${pkgs.coreutils}/bin/cat ${secretPath})"'
    '';
  });
  claude-code-sandboxed = sandbox.mkLinuxSandbox {
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
  };

in lib.mkMerge [
  {
    programs.bash.initExtra = ''
      ${builtins.readFile ./scripts/claude-task-completions.sh}
      ${builtins.readFile ./scripts/claude-switch.sh}
      ${builtins.readFile ./scripts/claude-delete.sh}
      ${builtins.readFile ./scripts/claude-delegate.sh}
      complete -F _claude_task_completions claude-switch
      complete -F _claude_task_completions claude-delete
    '';
    home.file = {
      ".claude/prompts/delegate.md" = {
        source = ./claude/prompts/delegate.md;
      };
      ".claude/settings.json" = { source = ./claude/settings.json; };
    };
  }
  (lib.mkIf pkgs.stdenv.isLinux { home.packages = [ claude-code-sandboxed ]; })
  (lib.mkIf pkgs.stdenv.isDarwin { home.packages = [ claude-code-authed ]; })
]
