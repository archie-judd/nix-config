{ pkgs-unstable, ... }: {
  programs.bash.initExtra = ''
    ${builtins.readFile ./scripts/copilot-task-completions.sh}
    ${builtins.readFile ./scripts/copilot-switch.sh}
    ${builtins.readFile ./scripts/copilot-delete.sh}
    ${builtins.readFile ./scripts/copilot-delegate.sh}
    complete -F _copilot_task_completions copilot-switch
    complete -F _copilot_task_completions copilot-delete
  '';

  home.file.".copilot/prompts/copilot-delegate.md" = {
    text = builtins.readFile ./prompts/copilot-delegate.md;
  };

  home.packages = [ pkgs-unstable.github-copilot-cli ];
}
