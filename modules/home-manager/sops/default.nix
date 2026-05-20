{ config, ... }:

/* Add new secrets to secrets.yml with:
   `SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt nix run nixpkgs#sops -- modules/home-manager/sops/secrets.yaml` (from the root of the repo)

   Add new binary secret files:
   1. Add a matching creation rule to .sops.yaml
   2. SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt nix run nixpkgs#sops --encrypt --input-type binary --output-type binary /path/to/file/<filename>  modules/home-manager/sops/<filename>
   (make sure the in and out filenames are the same)

   To add a new key:
   1. create a key file with: `age-keygen -o ~/.config/sops/age/keys.txt`
   2. Copy the public key and add it to your sops config at the the root of the repo (.sops.yaml)
   3. Push the changes to your git repo.
   4. Update the secrets file (on a machine that can already decrypt the secrets) with:
   `SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops updatekeys modules/home-manager/sops/secrets.yaml`
*/

{
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      claude-code-oauth-token = { };
      github-read-token = { };
      github-copilot-token = { };
      personal-git-crypt-key = {
        format = "binary";
        sopsFile = ./personal-git-crypt.key;
      };
    };
    templates."nix-access-tokens" = {
      content = ''
        access-tokens = github.com=${
          config.sops.placeholder."github-read-token"
        }
      '';
    };
  };

  # Gets written to ~/.config/nix/nix.conf and is used by nix commands. 
  nix.extraOptions = ''
    !include ${config.sops.templates."nix-access-tokens".path}
  '';

}
