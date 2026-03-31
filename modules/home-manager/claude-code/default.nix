{ config, pkgs, pkgs-unstable, inputs, ... }:
let
  github-read-token-path = config.sops.secrets.github-read-token.path;
  neovim =
    inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim-minimal;
  claude-sandboxed =
    inputs.agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system}.mkSandbox {
      pkg = pkgs-unstable.claude-code;
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
        GITHUB_TOKEN = "$(${pkgs.coreutils}/bin/cat ${github-read-token-path})";
        EDITOR = "nvim";
      };
      restrictNetwork = true;
      allowedDomains = {
        "anthropic.com" = "*";
        "claude.com" = "*";
      };

    };
in {
  home.packages = [ claude-sandboxed pkgs-unstable.claude-code ];
  home.file = {
    ".claude/settings.json" = { source = ./claude/settings.json; };
  };
  programs.bash.shellAliases = { cs = "claude-sandboxed"; };
  programs.bash.initExtra = ''
    qq() { local msg="$1"; shift; claude --model sonnet "$@" -p "$msg"; }
  '';
}
