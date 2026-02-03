{ pkgs, ... }:

{
  # 1. Use the latest kernel (Required for Meteor Lake camera support)
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  # 2. Enable firmware
  hardware.enableAllFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # 3. Intel camera driver
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6epmtl";
  };

  # 4. Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # 5. Add camera-specific packages
  # Because this is a separate file/module, NixOS will MERGE this list 
  # with the one in your main configuration.nix automatically!
  boot.blacklistedKernelModules = [ "v4l2loopback" ];
}
