{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    kolide = {
      url = "github:/kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ nixpkgs, home-manager, kolide, ... }: {
    nixosConfigurations = {
      xps-9510 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/xps-9510/configuration.nix
          kolide.nixosModules.kolide-launcher
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.archie = import ./home/users/work.nix;
          }
        ];
      };
    };
  };
}

