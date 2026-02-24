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

    neovim-config.url = "github:archie-judd/neovim-config?ref=refs/heads/main";

    claude-code-nix.url = "github:sadjow/claude-code-nix";

    bbc-to-spotify.url =
      "github:archie-judd/bbc-to-spotify?ref=refs/tags/v0.0.4";

    kolide-launcher = {
      url = "github:/kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin
    , sops-nix, neovim-config, claude-code-nix, bbc-to-spotify, kolide-launcher
    , ... }:
    let overlays = import ./overlays.nix;
    in {

      nixosConfigurations = {
        thinkpad-x1 = import ./hosts/thinkpad-x1 {
          nixpkgs = nixpkgs;
          nixpkgs-unstable = nixpkgs-unstable;
          home-manager = home-manager;
          overlays = overlays;
          sops-nix = sops-nix;
          claude-code-nix = claude-code-nix;
          neovim-config = neovim-config;
          kolide-launcher = kolide-launcher;
        };
      };

      darwinConfigurations = {
        macbook-pro = import ./hosts/macbook-pro {
          nixpkgs = nixpkgs;
          nixpkgs-unstable = nixpkgs-unstable;
          home-manager = home-manager;
          overlays = overlays;
          sops-nix = sops-nix;
          claude-code-nix = claude-code-nix;
          neovim-config = neovim-config;
          nix-darwin = nix-darwin;
        };
      };

      # Home manager only configurations
      homeConfigurations = {
        archiejudd = import ./hosts/nuc {
          nixpkgs = nixpkgs;
          nixpkgs-unstable = nixpkgs-unstable;
          home-manager = home-manager;
          overlays = overlays;
          neovim-config = neovim-config;
        };
        archie = import ./hosts/raspberry-pi {
          nixpkgs = nixpkgs;
          nixpkgs-unstable = nixpkgs-unstable;
          home-manager = home-manager;
          overlays = overlays;
          bbc-to-spotify = bbc-to-spotify;
        };
      };
    };
}
