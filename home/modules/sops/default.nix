{ config, ... }:

# Add new secrets with `nix run nixpkgs#sops -- home/modules/sops/secrets/secrets.yaml`
{
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.secrets.anthropic-api-key = { };
}
