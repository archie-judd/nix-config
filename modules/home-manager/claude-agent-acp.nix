{
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
let
  neovim = inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim-minimal;
  claude_config_dir = "$HOME/.claude";
  agent-sandbox = inputs.agent-sandbox-nix.lib.${pkgs.stdenv.hostPlatform.system};
  claude-agent-acp-sandboxed = agent-sandbox.mkSandbox {
    pkg = pkgs-unstable.claude-agent-acp;
    binName = "claude-agent-acp";
    outName = "claude-agent-acp";
    allowedPackages = agent-sandbox.commonTools ++ [
      neovim
      pkgs.gh
    ];
    rwDirs = [ claude_config_dir ];
    roFiles = [ "$HOME/.config/git/config" ];
    env = {
      CLAUDE_CONFIG_DIR = claude_config_dir;
      GH_TOKEN = "$(${pkgs.coreutils}/bin/cat $SOPS_DECRYPTED_DIR/github-read-token)";
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      CLAUDE_CODE_OAUTH_TOKEN = "$(${pkgs.coreutils}/bin/cat $SOPS_DECRYPTED_DIR/claude-code-oauth-token)";
    };
    allowedDomains = {
      "anthropic.com" = "*";
      "claude.com" = "*";
      "github.com" = "*";
      "githubusercontent.com" = [
        "GET"
        "HEAD"
      ];
    };
  };
in
{
  home.packages = [
    claude-agent-acp-sandboxed
  ];
}
