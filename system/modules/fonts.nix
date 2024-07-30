{ lib, pkgs, ... }:

{
  fonts = {
    packages = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  } # add these attributes if nixOS:
    // lib.attrsets.optionalAttrs pkgs.stdenv.isLinux {
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
