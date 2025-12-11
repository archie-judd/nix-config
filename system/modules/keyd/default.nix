{ ... }:

{
  # Key remaps
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(control, esc)";
            esc = "capslock";
          };
        };
      };
      hhkb_hybrid_type_s = {
        ids = [
          "04fe:0021:4f1b03d7" # bluetooth
          "04fe:0021:38fc4e01" # usb
        ];
        settings = {
          main = {
            control = "overload(control, esc)";
            esc = "control";
          };
        };
      };
    };
  };
}
