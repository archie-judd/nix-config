{ lib, pkgs, ... }:

{
  fonts = {
    packages = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  } // lib.attrsets.optionalAttrs pkgs.stdenv.isLinux {
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "JetBrainsMono" ];
        sansSerif = [ "JetBrainsMono" ];
        monospace = [ "JetBrainsMono" ];
      };
    };
  };
}
