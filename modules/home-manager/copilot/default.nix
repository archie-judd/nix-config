{ pkgs, pkgs-unstable, inputs, ... }:
let
  neovim =
    inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim-minimal;
  copilot-sandboxed =
    inputs.agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system}.mkSandbox {
      pkg = pkgs-unstable.github-copilot-cli;
      binName = "copilot";
      outName = "copilot-sandboxed"; # or whatever alias you'd like
      allowedPackages = [
        pkgs.coreutils
        pkgs.which
        pkgs.git
        pkgs.ripgrep
        pkgs.fd
        pkgs.gnused
        pkgs.gnugrep
        pkgs.findutils
        pkgs.jq
        neovim
      ]; # bash is allowed by default - it is required by the sandbox
      stateDirs = [ "$HOME/.config/github-copilot" "$HOME/.copilot" ];
      stateFiles = [ ];
      extraEnv = { };
      restrictNetwork = true;
      allowedDomains = {
        "githubcopilot.com" = "*";
        "github.com" = "*";
        "githubusercontent.com" = [ "GET" "HEAD" ];
      };
    };
in {
  home.packages = [ pkgs-unstable.github-copilot-cli copilot-sandboxed ];
  home.file = { ".copilot/hooks" = { source = ./copilot/hooks; }; };
}
