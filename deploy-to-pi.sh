#!/usr/bin/env bash
set -euo pipefail

USER="archie"
PI_HOST="${USER}@raspberry-pi.local"

nix build ".#homeConfigurations.${USER}.activationPackage"
nix copy --to "ssh://${PI_HOST}" ./result
ssh "$PI_HOST" "$(readlink ./result)/activate"
