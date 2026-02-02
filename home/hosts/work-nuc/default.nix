{ nixpkgs, nixpkgs-unstable, home-manager, neovim-config, ... }:
let system = "x86_64-linux";
in home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    system = system;
    config.allowUnfree = true;
  };
  modules = [ ../../profiles/work-nuc.nix ];
  extraSpecialArgs = {
    pkgs-unstable = import nixpkgs-unstable {
      system = system;
      config.allowUnfree = true;
    };
    nixpkgs = nixpkgs;
    neovim-config = neovim-config;
  };
}
