{ lib, pkgs, ... }:

{
  fonts = {
    packages = [ (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; }) ];

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
