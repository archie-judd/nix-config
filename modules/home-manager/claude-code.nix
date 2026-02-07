{ config, pkgs, ... }:

let
  secretPath = config.sops.secrets.claude-code-oauth-token.path;
  # We need to wrap the claude-code binaries to set the CLAUDE_CODE_OAUTH_TOKEN 
  # environment variable from the secret file.
  claude-code-wrapped = (pkgs.claude-code.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/claude \
        --run 'export CLAUDE_CODE_OAUTH_TOKEN="$(cat ${secretPath})"' 
    '';
  }));
  claude-code-acp-wrapped = (pkgs.claude-code-acp.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/claude-code-acp \
        --run 'export CLAUDE_CODE_OAUTH_TOKEN="$(cat ${secretPath})"' 
    '';
  }));
in {
  home.packages = [ claude-code-wrapped claude-code-acp-wrapped ];

}

