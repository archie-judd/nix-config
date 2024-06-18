{ ... }:

{
  virtualisation.docker.enable = true;
  users.users.archie = {
    extraGroups = [ "docker" ]; # docker added
  };
}
