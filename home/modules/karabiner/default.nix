{ ... }: {
  # see: https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/#about-symbolic-link
  home.file.".config/karabiner" = {
    source = ./karabiner;
    recursive = false;
    onChange = ''
      /bin/launchctl kickstart -k gui/`id -u`/org.pqrs.service.agent.karabiner_console_user_server
    '';
  };
}
