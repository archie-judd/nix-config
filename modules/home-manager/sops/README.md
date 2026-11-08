Add new secrets to an existing secrets.yaml file:
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt nix run nixpkgs#sops -- modules/home-manager/sops/secrets.yaml
(from the root of the repo)

Add a new secrets.yaml file:

1. Add a matching creation rule to .sops.yaml
1. SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt nix run nixpkgs#sops -- modules/home-manager/sops/secrets-new.yaml

Add new binary secret files:

1. Add a matching creation rule to .sops.yaml
1. SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt nix run nixpkgs#sops --encrypt --input-type binary --output-type binary /path/to/file/<filename> modules/home-manager/sops/<filename>
   (make sure the in and out filenames are the same)

To add a new key:

1. create a key file with: `age-keygen -o ~/.config/sops/age/keys.txt`
1. Copy the public key and add it to your sops config at the the root of the repo (.sops.yaml)
1. Push the changes to your git repo.
1. Update the secrets file (on a machine that can already decrypt the secrets) with:
   `SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops updatekeys modules/home-manager/sops/secrets.yaml`
