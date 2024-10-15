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
        program = "${pkgs.bashInteractive}/bin/bash";
        args = [ "-l" ];
      };
      terminal = { osc52 = "CopyPaste"; };
    } # Linux-only settings:
      // lib.attrsets.optionalAttrs pkgs.stdenv.isLinux {
        font = { size = 10; };
      } # Mac-only settings:
      // lib.attrsets.optionalAttrs pkgs.stdenv.isDarwin {
        font = {
          size = 14;
          normal = {
            # Go to the fonts app, hit command-i, and click on "details" to get the family
            family = "SauceCodePro NF";
            style = "Regular";
          };
          bold = {
            family = "SauceCodePro NF";
            style = "Bold";
          };
          italic = {
            family = "SauceCodePro NF";
            style = "Italic";
          };
          bold_italic = {
            family = "SauceCodePro NF";
            style = "BoldItalic";
          };
        };
        window = { option_as_alt = "OnlyRight"; };
      };
  };
}

