{ ... }: {
  programs.bash.shellAliases = {
    copilot-delegate = "copilot --agent delegate --yolo";
    copilot-resume = "copilot --agent delegate --yolo --continue";
  };
  home.file = {
    ".copilot/agents" = { source = ./copilot/agents; };
    ".copilot/hooks" = { source = ./copilot/hooks; };
  };
}
