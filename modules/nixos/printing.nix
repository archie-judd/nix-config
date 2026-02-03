{ pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Printing drivers
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.gutenprintBin
    pkgs.canon-cups-ufr2 # Canon's official driver package
    pkgs.cups-filters
  ];
}
