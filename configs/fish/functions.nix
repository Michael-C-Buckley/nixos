# Attribute names become Fish autoload filenames.
let
  mkFunction = name: description: body: ''
    function ${name} --description '${description}'
    ${body}
    end
  '';
  mkWidget =
    name: description: body:
    mkFunction name description (body + "\ncommandline -f repaint");
  gitPicker =
    name:
    {
      description,
      input,
      preview,
      action,
      options ? "",
    }:
    mkFunction name description ''
      command -q git; and command -q fzf; or begin
          echo '${name}: git and fzf are required' >&2
          return 127
      end
      command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return 1

      set -l selection (command git ${input} | \
          command fzf --height 60% --reverse --border ${options} \
              --preview '${preview}' --preview-window 'right:60%:wrap')
      ${action}
    '';
in
{
  __rb_fzf_cd_widget = mkWidget "__rb_fzf_cd_widget" "Change directory with the fcd picker" ''
    fcd
  '';
  __rb_fzf_file_widget = mkWidget "__rb_fzf_file_widget" "Insert a file selected with fzf" ''
    command -q fd; and command -q fzf; or return

    set -l file (command fd --type f --hidden --follow --exclude .git . | \
        command fzf --height 60% --reverse --border --prompt 'file> ' \
            --preview 'bat --color=always --style=numbers --line-range=:500 -- {} 2>/dev/null' \
            --preview-window 'right:60%:wrap')
    test -n "$file"; and commandline -rt -- (string escape -- "$file")
  '';
  __rb_fzf_history_widget = mkWidget "__rb_fzf_history_widget" "Search command history with fzf" ''
    command -q fzf; or return

    history merge
    set -l selection (history | command fzf --height 60% --reverse --border \
        --query (commandline) --prompt 'history> ')
    test -n "$selection"; and commandline -- "$selection"
  '';
  fcd = mkFunction "fcd" "Interactive directory change with fzf" ''
    set -l selected_path (fd . | fzf --height 40% --reverse)

    if test -n "$selected_path"
        if test -d "$selected_path"
            cd "$selected_path"
        else
            cd (dirname "$selected_path")
        end
    end
  '';
  fish_mode_prompt = mkFunction "fish_mode_prompt" "" "";
  # Prompts live in $__prompt_dir as <name>.fish (set by the wrapper)
  prompt = ''
    function __prompt_list --description 'List prompts the prompt command can switch to'
        set -q __prompt_dir[1]; or return
        set -l files $__prompt_dir/*.fish
        set -q files[1]; and path basename --no-extension -- $files
    end

    function prompt --description 'List prompts, or switch to one'
        argparse h/help s/save -- $argv; or return

        if set -q _flag_help
            echo 'Usage: prompt [--save] [NAME]'
            echo 'With no NAME, list the prompts and mark the active one.'
            echo '--save also makes NAME the default for new shells.'
            return
        end

        set -l available (__prompt_list)
        if not set -q argv[1]
            for name in $available
                if test "$name" = "$prompt_style"
                    echo "* $name"
                else
                    echo "  $name"
                end
            end
            return
        end

        if not contains -- $argv[1] $available
            echo "prompt: no prompt named '$argv[1]' (available: $available)" >&2
            return 1
        end

        # Prompts can define either function, so clear both before
        # loading the new one
        functions -e fish_prompt fish_right_prompt
        source $__prompt_dir/$argv[1].fish

        if set -q _flag_save
            # Drop the session value first so it doesn't shadow the saved one
            set -qg prompt_style; and set -eg prompt_style
            set -U prompt_style $argv[1]
        else
            set -g prompt_style $argv[1]
        end
        commandline -f repaint 2>/dev/null
        return 0
    end

    complete -c prompt -f -a '(__prompt_list)'
    complete -c prompt -s s -l save -d 'Also use it in new shells'
    complete -c prompt -s h -l help -d 'Show usage'
  '';
  show = mkFunction "show" "Show VTY command output" ''
    sudo vtysh -c (string join ' ' -- show $argv)
  '';
  sshf = ''
    function __ssh_config_hosts --description 'List concrete hosts from SSH config files'
        set -l config_files $HOME/.ssh/config

        if test -d $HOME/.ssh/config.d
            set -a config_files $HOME/.ssh/config.d/*.conf
        end

        awk '
            tolower($1) == "host" {
                for (i = 2; i <= NF; i++) {
                    if ($i ~ /^#/) break
                    if ($i !~ /[*!?]/) print $i
                }
            }
        ' $config_files 2>/dev/null | sort -fu
    end

    function sshf --description 'Choose an SSH host with fzf' --wraps ssh
        if not type -q fzf
            echo 'sshf: fzf is not installed' >&2
            return 127
        end

        set -l host (__ssh_config_hosts | fzf --height 40% --reverse --prompt 'ssh> ')
        test -n "$host"; or return

        command ssh $argv "$host"
    end
  '';
}
// builtins.mapAttrs gitPicker {
  gfa = {
    description = "Select changed files with fzf and stage them";
    input = "ls-files -m -d -o --exclude-standard";
    options = "--multi";
    preview = "git diff --color=always -- {}";
    action = ''test -n "$selection"; and command git add -A -- $selection'';
  };
  gfd = {
    description = "Select a changed file with fzf and view its unstaged diff";
    input = "ls-files -m -d";
    preview = "git diff --color=always -- {}";
    action = ''test -n "$selection"; and command git diff -- "$selection"'';
  };
  gfl = {
    description = "Select a commit with fzf and show it";
    input = "log --format='%C(auto)%h%x09%s%d'";
    options = "--ansi --delimiter '\\t' --with-nth '2..'";
    preview = "git show --color=always {1}";
    action = ''
      test -n "$selection"; or return
      set -l hash (string replace -r '\t.*' ''' -- "$selection")
      command git show "$hash"
    '';
  };
  gfrs = {
    description = "Select staged files with fzf and unstage them";
    input = "diff --cached --name-only";
    options = "--multi";
    preview = "git diff --cached --color=always -- {}";
    action = ''test -n "$selection"; and command git restore --staged -- $selection'';
  };
}
