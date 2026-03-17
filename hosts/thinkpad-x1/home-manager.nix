{ inputs, pkgs-unstable, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.archie = import ./home.nix;
  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ]; # Share sops config with all modules
  home-manager.extraSpecialArgs = {
    pkgs-unstable = pkgs-unstable;
    inputs = inputs;
  };
}
