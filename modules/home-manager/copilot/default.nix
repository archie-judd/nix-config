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
      stateDirs = [ "$HOME/.config/github-copilot" "$HOME/.copilot" ];
      stateFiles = [ ];
      extraEnv = {
        GITHUB_TOKEN =
          "$(${pkgs.coreutils}/bin/cat ${github-copilot-token-path})";
        EDITOR = "nvim";
      };
      allowedDomains = { "githubcopilot.com" = "*"; };
    };

in {
  programs.bash.shellAliases = { copilots = "copilot-sandboxed"; };
  home.packages = [ pkgs-unstable.copilot copilot-sandboxed ];
  home.file = { ".copilot/hooks" = { source = ./copilot/hooks; }; };
}
