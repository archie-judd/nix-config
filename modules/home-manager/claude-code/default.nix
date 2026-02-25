{ lib, config, pkgs, pkgs-unstable, claude-code-nix, ... }:
let
  secretPath = config.sops.secrets.claude-code-oauth-token.path;
  utils = import ./utils.nix { inherit pkgs secretPath; };
  claude-code-pkg =
    claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
  claude-code-authed = utils.withOAuthToken {
    pkg = claude-code-pkg;
    binName = "claude";
  };
  claude-code-acp-authed = utils.withOAuthToken {
    pkg = pkgs-unstable.claude-code-acp;
    binName = "claude-code-acp";
  };
  claude-code-sandboxed = utils.mkLinuxSandbox {
    pkg = claude-code-pkg;
    binName = "claude";
    outName = "claude";
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
      pkgs.tmux
    ];
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
      ".claude/prompts/claude-delegate.md" = {
        text = builtins.readFile ./claude/prompts/claude-delegate.md;
      };
      ".claude/settings.json" = {
        text = builtins.readFile ./claude/settings.json;
      };
    };
  }
  (lib.mkIf pkgs.stdenv.isLinux {
    home.packages = [ claude-code-acp-authed claude-code-sandboxed ];
  })
  (lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [ claude-code-acp-authed claude-code-authed ];
  })
]
