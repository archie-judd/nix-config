{ pkgs, ... }:

let
  git-branch-delete = pkgs.writeShellScriptBin "git-branch-delete"
    (builtins.readFile ./scripts/git-branch-delete.sh);
  git-tag-delete = pkgs.writeShellScriptBin "git-tag-delete"
    (builtins.readFile ./scripts/git-tag-delete.sh);
  git-review-pr = pkgs.writeShellScriptBin "git-review-pr"
    (builtins.readFile ./scripts/git-review-pr.sh);

in {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "archiejudd";
        email = "archie.judd@yahoo.com";
      };
      init.defaultBranch = "main";
      push.default = "nothing";
    };
    ignores = [ "*~" "*.swp" "*.swo" ".DS_Store" "fontlist-v330.json" ];
  };

  home.packages = [ git-branch-delete git-tag-delete git-review-pr ];

  programs.bash.initExtra = ''
        source ${pkgs.git}/share/bash-completion/completions/git
        __git_complete git-branch-delete _git_switch
        __git_complete git-tag-delete _git_switch
    		__git_complete git-review-pr _git_switch
            		'';

}
