{ pkgs-unstable, sops-nix, neovim-config, bbc-to-spotify, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.archie = import ./home.nix;
  home-manager.sharedModules =
    [ sops-nix.homeManagerModules.sops ]; # Share sops config with all modules
  home-manager.extraSpecialArgs = {
    pkgs-unstable = pkgs-unstable;
    neovim-config = neovim-config;
    bbc-to-spotify = bbc-to-spotify;
  };
}
