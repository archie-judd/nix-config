{ system, nixpkgs, nixpkgs-unstable, sops-nix, neovim-config, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
home-manager.users.archie = import ../../../home/profiles/work-laptop.nix;
  home-manager.sharedModules =
    [ sops-nix.homeManagerModules.sops ]; # Share sops config with all modules
  home-manager.extraSpecialArgs = {
    pkgs-unstable = import nixpkgs-unstable {
      system = system;
      config.allowUnfree = true;
    };
    nixpkgs = nixpkgs;
    neovim-config = neovim-config;
  };
}
