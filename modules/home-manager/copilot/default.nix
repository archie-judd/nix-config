{ config, pkgs, pkgs-unstable, inputs, ... }:
let
  github-copilot-token-path = config.sops.secrets.github-copilot-token.path;
  neovim =
    inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim-minimal;
  copilot-sandboxed =
    inputs.agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system}.mkSandbox {
      pkg = pkgs-unstable.github-copilot-cli;
      binName = "copilot";
      outName = "copilot-sandboxed";
      allowedPackages = [
        pkgs.coreutils
        pkgs.which
        pkgs.bash
        pkgs.git
        pkgs.ripgrep
        pkgs.fd
        pkgs.gnused
        pkgs.gnugrep
        pkgs.findutils
        pkgs.jq
        neovim
      ];
      stateDirs = [ "$HOME/.config/github-copilot" "$HOME/.copilot" ];
      stateFiles = [ ];
      extraEnv = {
        GITHUB_TOKEN =
          "$(${pkgs.coreutils}/bin/cat ${github-copilot-token-path})";
        EDITOR = "nvim";
        GIT_AUTHOR_NAME = "copilot-agent";
        GIT_AUTHOR_EMAIL = "copilot-agent@localhost";
        GIT_COMMITTER_NAME = "copilot-agent";
        GIT_COMMITTER_EMAIL = "copilot-agent@localhost";
      };
    };

in {
  home.packages = [ copilot-sandboxed ];
  home.file = { ".copilot/hooks" = { source = ./copilot/hooks; }; };
}
