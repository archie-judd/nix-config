{ config, pkgs, ... }:

let
  tasks-path = "${config.home.homeDirectory}/workspaces/personal/tasks.md";
  tmux-task-count = pkgs.writeShellScriptBin "tmux-task-count" ''
    file="${tasks-path}"
    [[ -f "$file" ]] || exit 0
    count=$(grep -c "^- \[ \]" "$file" 2>/dev/null || true)
    [[ "$count" -gt 0 ]] && echo " $count"
  '';
in {
  home.sessionVariables = {
    TASKS_PATH = tasks-path;
  };

  home.packages = [ tmux-task-count ];

  programs.bash.initExtra = ''
    t() {
      local file="$TASKS_PATH"
      [[ -f "$file" ]] || { mkdir -p "$(dirname "$file")" && touch "$file"; }
      case "''${1:-}" in
        "") $EDITOR "$file" ;;
        -l) grep -n "^- \[ \]" "$file" ;;
        *)  echo "- [ ] $(date +%F) $*" >> "$file" ;;
      esac
    }
  '';
}
