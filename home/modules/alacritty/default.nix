{ lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [ ./catppuccin-mocha.toml ];
      env = { TERM = "xterm-256color"; };
      window = {
        dimensions = {
          columns = 75;
          lines = 30;
        };
      };
    } # Linux-only settings:
      // lib.attrsets.optionalAttrs pkgs.stdenv.isLinux {
        font = { size = 10; };
        shell = { program = "tmux"; }; # couldn't get this option working on mac
      } # Mac-only settings:
      // lib.attrsets.optionalAttrs pkgs.stdenv.isDarwin {
        font = {
          size = 14;
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrainsMono Nerd Font";
            style = "BoldItalic";
          };
        };
      };
  };
}

