{ pkgs, ... }:

{
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  #ADDITIONS:

  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = "experimental-features = nix-command flakes";

  imports = [ ../../modules/fonts.nix ];

  environment.systemPackages = [ pkgs.vim ];

  # A list of permissable shells for login accounts
  environment.shells = [ pkgs.bashInteractive ];
  # enable bash as an interactive shell 
  programs.bash.enable = true;
  # the users's default shell
  users.users.archie = {
    home = "/Users/archie";
    shell = pkgs.bashInteractive;
  };

  # don't try to symlink the json, it breaks stuff
  services.karabiner-elements.enable = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-time-modifier = 0.75;
  system.defaults.dock.show-recents = false;

  # trackpad speed (1.0 - 3.0)
  system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
}
