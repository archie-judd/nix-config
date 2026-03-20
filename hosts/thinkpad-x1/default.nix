{ inputs, overlays }:

let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs {
    system = system;
    config.allowUnfree = true;
    overlays = overlays;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = system;
    config.allowUnfree = true;
    overlays = overlays;
  };
in inputs.nixpkgs.lib.nixosSystem {
  system = system;
  pkgs = pkgs;
  specialArgs = {
    pkgs-unstable = pkgs-unstable;
    inputs = inputs;
  };
  modules = [
    ./configuration.nix
    ./home-manager.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.kolide-launcher.nixosModules.kolide-launcher
  ];
}
