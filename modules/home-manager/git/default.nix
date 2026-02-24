{ pkgs, ... }:

let
  git-branch-rm = pkgs.writeShellScriptBin "git-branch-rm"
    (builtins.readFile ./scripts/git-branch-rm.sh);
  git-tag-rm = pkgs.writeShellScriptBin "git-tag-rm"
    (builtins.readFile ./scripts/git-tag-rm.sh);

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

  home.packages = [ git-branch-rm git-tag-rm ];

  programs.bash.initExtra = ''
    source ${pkgs.git}/share/bash-completion/completions/git
    __git_complete git-branch-rm _git_switch
    __git_complete git-tag-rm _git_switch
        		'';

}
