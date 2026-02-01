{ pkgs, ... }:

{
  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  #ADDITIONS:

  system.primaryUser = "archie";

  nixpkgs.config.allowUnfree = true;

  nix.extraOptions = "experimental-features = nix-command flakes";

  imports = [
    ../../modules/fonts.nix
    ../../modules/homebrew.nix
    ../../modules/mac-os.nix
  ];

  environment.systemPackages = [ pkgs.vim ];

  # A list of permissable shells for login accounts
  environment.shells = [ pkgs.bashInteractive ];
  # enable bash as an interactive shell 
  programs.bash.enable = true;
  # the users's default shell
  users.knownUsers = [ "archie" ];
  users.users.archie = {
    home = "/Users/archie";
    shell = pkgs.bashInteractive;
    uid = 501;
  };

  # Nix garbage collection
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 0;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };

}
