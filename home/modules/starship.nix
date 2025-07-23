{ ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      time = {
        disabled = false;
        format = "[ $time ]($style) ";
        time_format = "%T";
      };
    };
  };
}

