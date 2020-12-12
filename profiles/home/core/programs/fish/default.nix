{
  programs.fish = {
    enable = true;
    shellAliases = {
      "ls" = "exa -FsName --group-directories-first";
      "ll" = "exa -FlsName --group-directories-first";
      "l" = "exa -FlasName --group-directories-first";
      "la" = "exa -FlasName --group-directories-first";
      "nv" = "nvim";
    };

    interactiveShellInit = ''
      set -U fish_color_normal normal
      set -U fish_color_command brgreen --bold
      set -U fish_color_quote brblue
      set -U fish_color_redirection black
      set -U fish_color_end 969696
      set -U fish_color_error brred --bold
      set -U fish_color_param brcyan
      set -U fish_color_selection white --bold --background=brblack
      set -U fish_color_search_match bryellow --background=brblack
      set -U fish_color_history_current --bold
      set -U fish_color_operator brmagenta
      set -U fish_color_escape brmagenta
      set -U fish_color_cwd green
      set -U fish_color_cwd_root red
      set -U fish_color_valid_path --underline
      set -U fish_color_autosuggestion 7f7f7f
      set -U fish_color_cancel -r
      set -U fish_pager_color_completion normal
      set -U fish_pager_color_description B3A06D yellow
      set -U fish_pager_color_prefix white --bold --underline
      set -U fish_pager_color_progress brwhite --background=cyan
      set -U fish_color_match --background=brblue
      set -U fish_color_comment 7f7f7f

      function fish_greeting
      end

      function fish_title
        set realhome ~
        set -l tmp (string replace -r '^'"$realhome"'($|/)' '~$1' $PWD)
        echo $USER'@'(prompt_hostname)" "$tmp
      end
    '';

    promptInit = ''
      function fish_prompt
        set -l last_status $status
        set_color -o brmagenta
        echo -n $USER
        set_color normal
        set_color black
        echo -n '@'
        set_color brmagenta
        echo -n (prompt_hostname)" "
        set_color -i bryellow
        echo -n (prompt_pwd)
        set_color normal
        fish_git_prompt
        set_color -o brblack

        if [ "$IN_NIX_SHELL" != "" ]
          set_color -o brcyan
        end

        if [ $last_status -ne 0 ]
          set_color -o brred
        end
          
        echo
        echo -n '; '
        set_color normal
      end

      function fish_right_prompt
        set_color black
        echo -n "["(date +%T)"]"
        set_color normal
      end
    '';
  };
}
