{ nixpkgs, pkgs-unstable, sops-nix, neovim-config, claude-code-nix, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.archie = import ./home.nix;
  home-manager.sharedModules =
    [ sops-nix.homeManagerModules.sops ]; # Share sops config with all modules
  home-manager.extraSpecialArgs = {
    nixpkgs = nixpkgs;
    pkgs-unstable = pkgs-unstable;
    neovim-config = neovim-config;
    claude-code-nix = claude-code-nix;
  };
}
