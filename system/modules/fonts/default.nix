{ lib, pkgs, ... }:

{
  fonts = {
    packages = [ pkgs.nerd-fonts.sauce-code-pro ];

  } # add these attributes if nixOS:
    // lib.attrsets.optionalAttrs pkgs.stdenv.isLinux {
      enableDefaultPackages = true;
      fontconfig = {
        defaultFonts = {
          serif = [ "SourceCodePro" ];
          sansSerif = [ "SourceCodePro" ];
          monospace = [ "SourceCodePro" ];
        };
      };
    };
}
