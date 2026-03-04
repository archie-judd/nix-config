{ nixpkgs, pkgs-unstable, sops-nix, neovim-config, agent-sandbox-nix
, claude-code-nix, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.archie = import ./home.nix;
  home-manager.sharedModules =
    [ sops-nix.homeManagerModules.sops ]; # Share sops config with all modules
  home-manager.extraSpecialArgs = {
    nixpkgs = nixpkgs;
    pkgs-unstable = pkgs-unstable;
    neovim-config = neovim-config;
    agent-sandbox-nix = agent-sandbox-nix;
    claude-code-nix = claude-code-nix;
  };
}
