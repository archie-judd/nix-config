[
  (final: prev: {
    # https://github.com/tailscale/tailscale/issues/16966
    tailscale = prev.tailscale.overrideAttrs (old: {
      checkFlags = builtins.map (flag:
        if prev.lib.hasPrefix "-skip=" flag then
          flag + "|^TestGetList$|^TestIgnoreLocallyBoundPorts$|^TestPoller$"
        else
          flag) old.checkFlags;
    });
    # ensure that the copilot cli has the correct SSL certs
    github-copilot-cli = (prev.github-copilot-cli.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ])
        ++ [ prev.makeWrapper ];
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/copilot \
          --set SSL_CERT_DIR "${prev.cacert}/etc/ssl/certs"
      '';
    }));

  })
]
