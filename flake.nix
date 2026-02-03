{
  description = "NixOS configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";

    bbc-to-spotify.url =
      "github:archie-judd/bbc-to-spotify?ref=refs/tags/v0.0.4";

    neovim-config.url = "github:archie-judd/neovim-config?ref=refs/heads/main";

    kolide-launcher = {
      url = "github:/kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin
    , sops-nix, bbc-to-spotify, neovim-config, kolide-launcher, ... }:
    let overlays = import ./overlays.nix;
    in {

      # NixOS configurations
      nixosConfigurations = {
        thinkpad-x1 = import ./hosts/thinkpad-x1 {
          nixpkgs = nixpkgs;
          nixpkgs-unstable = nixpkgs-unstable;
          home-manager = home-manager;
          overlays = overlays;
          sops-nix = sops-nix;
          neovim-config = neovim-config;
          kolide-launcher = kolide-launcher;
        };
      };

      # Darwin configurations
      darwinConfigurations = {
        macbook-pro = import ./hosts/macbook-pro {
          nixpkgs = nixpkgs;
          nixpkgs-unstable = nixpkgs-unstable;
          home-manager = home-manager;
          overlays = overlays;
          sops-nix = sops-nix;
          neovim-config = neovim-config;
          nix-darwin = nix-darwin;
        };
      };

      # Home manager only configurations
      homeConfigurations = {
        # Work NUC
        archiejudd = import ./hosts/work-nuc {
          nixpkgs = nixpkgs;
          nixpkgs-unstable = nixpkgs-unstable;
          home-manager = home-manager;
          overlays = overlays;
          neovim-config = neovim-config;
        };
        # Rpi
        archie = import ./hosts/personal-rpi {
          nixpkgs = nixpkgs;
          nixpkgs-unstable = nixpkgs-unstable;
          home-manager = home-manager;
          overlays = overlays;
          bbc-to-spotify = bbc-to-spotify;
        };
      };
    };
}
