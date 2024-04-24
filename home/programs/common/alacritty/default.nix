{ config, pkgs, lib, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [ ./catppuccin-macchiato.toml ];
      env = { TERM = "xterm-256color"; };
      font = { size = 10; };
      window = {
        dimensions = {
          columns = 75;
          lines = 30;
        };
      };
    };
  };
}

