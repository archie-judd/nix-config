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
      hhkb = {
        ids = [ "04fe:0021:4f1b03d7" ];
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
