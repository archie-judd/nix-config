{ config, lib, pkgs, ... }:

# Add new secrets with:
# `nix run nixpkgs#sops -- modules/home-manager/sops/secrets.yaml` (from the root of the repo)

# To add a new key:
# 1. create a key file with: `age-keygen -o ~/.config/sops/age/keys.txt`
# 2. Copy the public key and add it to your sops config at the the root of the repo (.sops.yaml)
# 3. Push the changes to your git repo.
# 4. Update the secrets file (on a machine that can already decrypt the secrets) with:
# `SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops updatekeys modules/home-manager/sops/secrets.yaml`

let sopsDir = "${config.home.homeDirectory}/.config/sops";
in {
  sops = {
    age.keyFile = "${sopsDir}/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      anthropic-api-key = { };

    };
  };

  # master had a mac bug: https://github.com/Mic92/sops-nix/issues/890
  launchd.agents.sops-nix = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      EnvironmentVariables = {
        PATH = lib.mkForce "/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };

}
