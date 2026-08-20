{ config, pkgs, ... }:

let
  tasks-path = "${config.home.homeDirectory}/workspaces/notes/work/tasks.md";
  tmux-task-count = pkgs.writeShellScriptBin "tmux-task-count" ''
    file="${tasks-path}"
    [[ -f "$file" ]] || exit 0
    count=$(grep -c "^- \[ \]" "$file" 2>/dev/null || true)
    [[ "$count" -gt 0 ]] && echo " $count"
  '';
in
{
  home.sessionVariables = {
    TASKS_PATH = tasks-path;
  };

  home.packages = [ tmux-task-count ];

  programs.bash.initExtra =
    # bash
    ''
      tasks() {
        local file="$TASKS_PATH"
        [[ -f "$file" ]] || { mkdir -p "$(dirname "$file")" && touch "$file"; }
        case "''${1:-}" in
          -l) grep -n "^- \[ \]" "$file" ;;
          *)  $EDITOR "$file" ;;
        esac
      }
    '';
}
