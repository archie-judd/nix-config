{ nixpkgs, pkgs-unstable, sops-nix, neovim-config, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.archie = import ./home.nix;
  home-manager.sharedModules =
    [ sops-nix.homeManagerModules.sops ]; # Share sops config with all modules
  home-manager.extraSpecialArgs = {
    nixpkgs = nixpkgs;
    pkgs-unstable = pkgs-unstable;
    neovim-config = neovim-config;
  };
}
