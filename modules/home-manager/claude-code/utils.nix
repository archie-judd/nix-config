{ pkgs, secretPath }: {
  # We need to wrap the claude-code binaries to set the CLAUDE_CODE_OAUTH_TOKEN 
  # environment variable from the secret file.
  withOAuthToken = { pkg, binName }:
    pkg.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ])
        ++ [ pkgs.makeWrapper ];
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/${binName} \
          --run 'export CLAUDE_CODE_OAUTH_TOKEN="$(${pkgs.coreutils}/bin/cat ${secretPath})"'
      '';
    });

  mkLinuxSandbox = { pkg, binName, outName, allowedPackages }:
    let basePath = pkgs.lib.makeBinPath allowedPackages;
    in pkgs.writeShellScriptBin outName ''
      CWD=$(pwd)
      TOKEN=$(${pkgs.coreutils}/bin/cat ${secretPath})
      mkdir -p "$HOME/.claude"
      touch "$HOME/.claude.json"
      GIT_DIR=$(${pkgs.git}/bin/git rev-parse --path-format=absolute --git-common-dir 2>/dev/null || echo "$CWD/.git")

      exec ${pkgs.bubblewrap}/bin/bwrap \
        --ro-bind /nix/store /nix/store \
        --ro-bind /etc/resolv.conf /etc/resolv.conf \
        --ro-bind /etc/ssl/certs /etc/ssl/certs \
        --proc /proc \
        --dev /dev \
        --tmpfs /tmp \
        --tmpfs "$HOME" \
        --bind "$CWD" "$CWD" \
        --bind "$GIT_DIR" "$GIT_DIR" \
        --bind "$HOME/.claude" "$HOME/.claude" \
        --bind "$HOME/.claude.json" "$HOME/.claude.json" \
        --symlink ${pkgs.bash}/bin/bash /bin/sh \
        --unshare-all \
        --share-net \
        --die-with-parent \
        --chdir "$CWD" \
        --setenv HOME "$HOME" \
        --setenv TERM "$TERM" \
        --setenv SHELL "${pkgs.bash}/bin/bash" \
        --setenv PATH "${basePath}" \
        --setenv CLAUDE_CODE_OAUTH_TOKEN "$TOKEN" \
        --setenv NODE_EXTRA_CA_CERTS "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" \
        --setenv GIT_AUTHOR_NAME "claude-agent" \
        --setenv GIT_AUTHOR_EMAIL "claude-agent@localhost" \
        --setenv GIT_COMMITTER_NAME "claude-agent" \
        --setenv GIT_COMMITTER_EMAIL "claude-agent@localhost" \
        ${pkg}/bin/${binName} "$@"
    '';
}
