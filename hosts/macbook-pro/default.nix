{ inputs, overlays }:

let
  system = "aarch64-darwin";
  allowUnfreePredicate = pkg:
    builtins.elem (inputs.nixpkgs.lib.getName pkg) [
      "claude-code"
      "github-copilot-cli"
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
in inputs.nix-darwin.lib.darwinSystem {
  system = system;
  pkgs = pkgs;
  specialArgs = {
    pkgs-unstable = pkgs-unstable;
    inputs = inputs;
  };

  modules = [
    ./configuration.nix
    ./home-manager.nix
    inputs.home-manager.darwinModules.home-manager
  ];
}
