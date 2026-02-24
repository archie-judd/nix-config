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
      ${builtins.readFile ./scripts/claude-cd.sh}
      ${builtins.readFile ./scripts/claude-rm.sh}
      complete -F _claude_task_completions claude-cd
      complete -F _claude_task_completions claude-rm
    '';
    home.file = {
      ".claude/rules/git-workflow.md" = {
        text = builtins.readFile ./claude/rules/git-workflow.md;
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
