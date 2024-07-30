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
      shell = {
        program = "${pkgs.bash}/bin/bash";
        args = [ "-l" "-c" "tmux-attach || tmux" ];
      };
    } # Linux-only settings:
      // lib.attrsets.optionalAttrs pkgs.stdenv.isLinux {
        font = { size = 10; };
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
        # Send alt-c for Option-c (so fzf alt-c command works) 
        keyboard = {
          bindings = [{
            key = "c";
            mods = "Option";
            chars = "\\u001bc";
          }];
        };
      };
  };
}

