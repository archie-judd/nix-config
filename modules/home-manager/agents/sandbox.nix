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
  mkDarwinSandbox = { pkg, binName, outName, allowedPackages, stateDirs ? [ ]
    , stateFiles ? [ ], extraEnv ? { } }:
    let
      basePath = pkgs.lib.makeBinPath allowedPackages;
      # Generate indexed param names
      stateDirParams = builtins.genList (i: {
        name = "STATE_DIR_${toString i}";
        path = builtins.elemAt stateDirs i;
      }) (builtins.length stateDirs);

      stateFileParams = builtins.genList (i: {
        name = "STATE_FILE_${toString i}";
        path = builtins.elemAt stateFiles i;
      }) (builtins.length stateFiles);

      # For the .sb file
      seatbeltAllowReadWrite = builtins.concatStringsSep "\n" (map
        (p: ''(allow file-read* file-write* (subpath (param "${p.name}")))'')
        stateDirParams);

      seatbeltAllowFiles = builtins.concatStringsSep "\n" (map
        (p: ''(allow file-read* file-write* (literal (param "${p.name}")))'')
        stateFileParams);

      # For the wrapper's sandbox-exec invocation
      stateDirFlags = builtins.concatStringsSep " \\\n  "
        (map (p: ''-D ${p.name}="${p.path}"'') stateDirParams);

      stateFileFlags = builtins.concatStringsSep " \\\n  "
        (map (p: ''-D ${p.name}="${p.path}"'') stateFileParams);

      mkDirsStr = builtins.concatStringsSep "\n"
        (map (dir: ''mkdir -p "${dir}"'') stateDirs);
      mkFilesStr = builtins.concatStringsSep "\n"
        (map (file: ''touch "${file}"'') stateFiles);

      extraEnvStr = builtins.concatStringsSep "\n"
        (map (name: ''export ${name}="${extraEnv.${name}}"'')
          (builtins.attrNames extraEnv));

      seatbeltProfile = pkgs.writeText "${outName}-sandbox.sb" ''
        (version 1)
        (deny default)

        ;; Process control
        (allow process-exec)
        (allow process-fork)
        (allow signal)
        (allow sysctl-read)

        ;; Mach IPC — scoped to system services, security framework, FSEvents
        (allow mach-lookup (global-name-prefix "com.apple.system."))
        (allow mach-lookup (global-name-prefix "com.apple.SystemConfiguration."))
        (allow mach-lookup (global-name "com.apple.securityd.xpc"))
        (allow mach-lookup (global-name "com.apple.SecurityServer"))
        (allow mach-lookup (global-name "com.apple.trustd.agent"))
        (allow mach-lookup (global-name "com.apple.FSEvents"))
        (allow mach-register)
        (allow ipc-posix-shm-read-data)
        (allow ipc-posix-shm-write-data)
        (allow ipc-posix-shm-write-create)

        ;; Network
        (allow network*)

        ;; Device nodes & terminal I/O
        (allow file-read*
          (literal "/dev/null")
          (literal "/dev/urandom")
          (literal "/dev/random")
          (literal "/dev/zero"))
        (allow file-write* (literal "/dev/null"))
        (allow file-read* file-write*
          (literal "/dev/tty")
          (regex #"^/dev/fd/")
          (regex #"^/dev/ttys[0-9]"))
        (allow file-ioctl
          (literal "/dev/tty")
          (regex #"^/dev/ttys[0-9]"))

        ;; System libraries & frameworks
        (allow file-read*
          (subpath "/usr/lib")
          (subpath "/usr/share")
          (subpath "/System")
          (subpath "/Library/Preferences"))

        ;; Nix store (read-only)
        (allow file-read* (subpath "/nix"))

        ;; DNS, TLS & name resolution
        (allow file-read*
          (literal "/etc/resolv.conf")
          (literal "/private/etc/resolv.conf")
          (literal "/private/var/run/resolv.conf")
          (subpath "/etc/ssl")
          (subpath "/private/etc/ssl")
          (literal "/etc/passwd")
          (literal "/private/etc/passwd"))

        ;; Security framework — system keychains & trust databases
        (allow file-read*
          (subpath "/Library/Keychains")
          (subpath "/private/var/db/mds")
          (literal "/private/var/run/systemkeychaincheck.done"))

        ;; Temp directories
        (allow file-read* file-write*
          (subpath "/tmp")
          (subpath "/private/tmp")
          (subpath (param "TMPDIR"))
          (subpath "/private/var/folders"))

        ;; Timezone
        (allow file-read* (subpath "/private/var/db/timezone"))

        ;; Filesystem traversal — stat() on parent dirs for path resolution
        (allow file-read*
          (literal "/")
          (literal "/var")
          (literal "/private")
          (literal "/private/var")
          (literal "/Users")
          (literal (param "HOME"))
          (literal (param "CWD_PARENT"))
          (literal (param "REPO_ROOT_PARENT")))

        ;; Working directory & repository
        (allow file-read* file-write* (subpath (param "CWD")))
        (allow file-read* file-write* (subpath (param "REPO_ROOT")))
        (allow file-read* file-write* (subpath (param "GIT_DIR")))
        (allow file-read* (subpath (param "GIT_CONFIG_DIR")))

        ;; Explicit state directories & files
        ${seatbeltAllowReadWrite}
        ${seatbeltAllowFiles};
      '';

    in pkgs.writeShellScriptBin outName ''
      CWD=$(pwd)
      ${mkDirsStr}
      ${mkFilesStr}

      if GIT_DIR=$(${pkgs.git}/bin/git rev-parse --path-format=absolute --git-common-dir 2>/dev/null); then
        GIT_DIR_PARAM="$GIT_DIR"
      else
        GIT_DIR_PARAM="/nonexistent-git-dir"
      fi

      export HOME="$HOME"
      export TERM="$TERM"
      export SHELL="${pkgs.bash}/bin/bash"
      export PATH="${basePath}"
      export SSL_CERT_FILE="''${SSL_CERT_FILE:-/etc/ssl/certs/ca-certificates.crt}"
      export SSL_CERT_DIR="''${SSL_CERT_DIR:-/etc/ssl/certs}"
      ${extraEnvStr}
      export CWD_PARENT="$(dirname "$CWD")"
      export REPO_ROOT=$(dirname "$GIT_DIR_PARAM")
      export REPO_ROOT_PARENT=$(dirname "$REPO_ROOT")
      export GIT_CONFIG_DIR="$HOME/.config/git"


      exec /usr/bin/sandbox-exec \
        -f ${seatbeltProfile} \
        -D CWD="$CWD" \
        -D CWD_PARENT="$CWD_PARENT" \
        -D GIT_DIR="$GIT_DIR_PARAM" \
        -D REPO_ROOT="$REPO_ROOT" \
        -D REPO_ROOT_PARENT="$REPO_ROOT_PARENT" \
        -D GIT_CONFIG_DIR="$GIT_CONFIG_DIR" \
        -D TMPDIR="''${TMPDIR:-/tmp}" \
        -D HOME="$HOME" ${stateDirFlags} ${stateFileFlags} \
        ${pkg}/bin/${binName} "$@"
    '';
}
