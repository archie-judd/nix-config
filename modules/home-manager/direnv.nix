{ ... }:

{
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    # Write the following the global .direnvrc file: If the TMUX_PANE environment variable is set don't restore it from the cache, reset it from the global environment.
    stdlib = ''
      if [[ -n "$''${TMUX_PANE}" ]]; then
      	export TMUX_PANE=$(env | grep '^TMUX_PANE=' | cut -d= -f2-)
      fi
    '';

  };

}
