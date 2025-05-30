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
        ids = [ "04fe:0021:f26878c3" ];
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
