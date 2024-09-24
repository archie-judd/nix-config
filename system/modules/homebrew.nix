{ ... }:

{
  # Install GUI programs and AppStore apps with homebrew
  homebrew = {
    enable = true;
    casks =
      [ "1password" "karabiner-elements" "vlc" "rectangle" "spotify" "maccy" ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "istat Menus" = 1319778037;
    };
  };
}
