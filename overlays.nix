[
  (final: prev: {
    # https://github.com/tailscale/tailscale/issues/16966
    tailscale = prev.tailscale.overrideAttrs (old: {
      checkFlags = map (
        flag:
        if prev.lib.hasPrefix "-skip=" flag then
          flag + "|^TestGetList$|^TestIgnoreLocallyBoundPorts$|^TestPoller$"
        else
          flag
      ) old.checkFlags;
    });

    # https://github.com/NixOS/nixpkgs/pull/554467
    # Drop once that lands in nixos-26.05; without StartupWMClass the shell
    # treats the window as unmatched, so it cannot be pinned to the dash.
    obsidian = prev.obsidian.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        chmod +w $out/share/applications/obsidian.desktop
        echo "StartupWMClass=md.Obsidian" >> $out/share/applications/obsidian.desktop
      '';
    });
  })
]
