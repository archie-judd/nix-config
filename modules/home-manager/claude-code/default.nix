{ ... }: {

  programs.bash.shellAliases = {
    claude-delegate = ''
      claude --append-system-prompt-file "$HOME/.claude/prompts/delegate.md" --dangerously-skip-permissions'';
    claude-resume = ''
      claude --continue --append-system-prompt-file "$HOME/.claude/prompts/delegate.md" --dangerously-skip-permissions'';
  };
  home.file = {
    ".claude/prompts/delegate.md" = { source = ./claude/prompts/delegate.md; };
    ".claude/settings.json" = { source = ./claude/settings.json; };
  };
}
