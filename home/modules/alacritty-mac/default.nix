{ ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [ ./catppuccin-mocha.toml ];
      env = { TERM = "xterm-256color"; };
      font = { size = 10; };
      window = {
        dimensions = {
          columns = 75;
          lines = 30;
        };
      };
    };
  };
}

