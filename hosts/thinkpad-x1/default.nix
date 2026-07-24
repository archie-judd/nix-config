{ inputs, overlays }:

let
  system = "x86_64-linux";
  allowUnfreePredicate =
    pkg:
    builtins.elem (inputs.nixpkgs.lib.getName pkg) [
      "canon-cups-ufr2"
      "github-copilot-cli"
      "claude-code"
      "claude-desktop"
      "1password"
      "1password-cli"
      "slack"
      "spotify"
      "kolide-launcher"
    ];
  pkgs = import inputs.nixpkgs {
    system = system;
    overlays = overlays;
    config.allowUnfreePredicate = allowUnfreePredicate;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = system;
    overlays = overlays;
    config.allowUnfreePredicate = allowUnfreePredicate;
  };
  pkgs-claude-desktop = import inputs.nixpkgs-claude-desktop {
    system = system;
    overlays = overlays;
    config.allowUnfreePredicate = allowUnfreePredicate;
  };
in
inputs.nixpkgs.lib.nixosSystem {
  system = system;
  pkgs = pkgs;
  specialArgs = {
    pkgs-unstable = pkgs-unstable;
    pkgs-claude-desktop = pkgs-claude-desktop;
    inputs = inputs;
  };
  modules = [
    ./configuration.nix
    ./home-manager.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.kolide-launcher.nixosModules.kolide-launcher
  ];
}
