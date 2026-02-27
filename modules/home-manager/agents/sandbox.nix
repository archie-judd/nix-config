{ pkgs }: {
  mkLinuxSandbox = { pkg, binName, outName, allowedPackages, stateDirs ? [ ]
    , stateFiles ? [ ], extraEnv ? { } }:
    let
      basePath = pkgs.lib.makeBinPath allowedPackages;
      mkDirsStr = builtins.concatStringsSep "\n"
        (map (dir: ''mkdir -p "${dir}"'') stateDirs);
      mkFilesStr = builtins.concatStringsSep "\n"
        (map (file: ''touch "${file}"'') stateFiles);
      bindDirsStr = builtins.concatStringsSep " "
        (map (dir: ''--bind "${dir}" "${dir}"'') stateDirs);
      bindFilesStr = builtins.concatStringsSep " "
        (map (file: ''--bind "${file}" "${file}"'') stateFiles);
      extraEnvStr = builtins.concatStringsSep " "
        (map (name: ''--setenv ${name} "${extraEnv.${name}}"'')
          (builtins.attrNames extraEnv));
    in pkgs.writeShellScriptBin outName ''
      CWD=$(pwd)
      ${mkDirsStr}
      ${mkFilesStr}
      GIT_BIND=""
      if GIT_DIR=$(${pkgs.git}/bin/git rev-parse --path-format=absolute --git-common-dir 2>/dev/null); then
        GIT_BIND="--bind $GIT_DIR $GIT_DIR"
      fi
      exec ${pkgs.bubblewrap}/bin/bwrap \
        --ro-bind /nix/store /nix/store \
        --ro-bind /etc/passwd /etc/passwd \
        --ro-bind /etc/resolv.conf /etc/resolv.conf \
        --ro-bind /etc/ssl/certs /etc/ssl/certs \
        --proc /proc \
        --dev /dev \
        --tmpfs /tmp \
        --tmpfs "$HOME" \
        --bind "$CWD" "$CWD" \
        ${bindDirsStr} \
        ${bindFilesStr} \
        $GIT_BIND \
        --symlink ${pkgs.bash}/bin/bash /bin/sh \
        --unshare-all \
        --share-net \
        --die-with-parent \
        --chdir "$CWD" \
        --setenv HOME "$HOME" \
        --setenv TERM "$TERM" \
        --setenv SHELL "${pkgs.bash}/bin/bash" \
        --setenv PATH "${basePath}" \
        --setenv SSL_CERT_FILE "$SSL_CERT_FILE" \
        --setenv SSL_CERT_DIR "$SSL_CERT_DIR" \
        ${extraEnvStr} \
        ${pkg}/bin/${binName} "$@"
    '';
}
