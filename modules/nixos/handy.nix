{ ... }:

{
  hardware.uinput.enable = true;
  users.users.archie.extraGroups = [ "uinput" ];
}
