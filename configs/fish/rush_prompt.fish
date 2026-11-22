# Two-line Fish-native prompt matching the Rush configuration.

function __rb_prompt_git_root
    command -q git; or return 1
    command git rev-parse --show-toplevel 2>/dev/null
end

function __rb_prompt_directory
    set -l git_root (__rb_prompt_git_root)
    set -l color cyan
    set -l directory
    test (id -u) -eq 0; and set color red

    if test -n "$git_root"
        if test "$PWD" = "$git_root"
            set directory (path basename -- "$git_root")
        else
            set directory (string replace -- "$git_root/" '' "$PWD")
            set directory (path basename -- "$git_root")/$directory
        end
        printf '%s%s%s' (set_color $color) $directory (set_color normal)
    else
        printf '%s%s%s' (set_color $color) (prompt_pwd) (set_color normal)
    end
end

function __rb_prompt_git_start_refresh --argument-names repository_key
    set -l temp_dir /tmp
    if set -q TMPDIR[1]; and test -d "$TMPDIR"; and test -w "$TMPDIR"
        set temp_dir (string replace --regex '/$' '' -- "$TMPDIR")
    end

    set -l status_file (command mktemp "$temp_dir/rb-fish-git.XXXXXX" 2>/dev/null)
    test -n "$status_file"; or return 1

    command git status --porcelain=v2 --branch --show-stash >"$status_file" 2>/dev/null &
    set -l refresh_pid $last_pid
    if test -z "$refresh_pid"
        command rm -f -- "$status_file"
        return 1
    end

    set -g __rb_prompt_git_refreshing $refresh_pid
    set -g __rb_prompt_git_refresh_repository_key $repository_key
    set -g __rb_prompt_git_status_file $status_file

    function __rb_prompt_git_refresh_complete --on-process-exit $refresh_pid
        set -l completed_status_file $__rb_prompt_git_status_file
        set -l completed_repository_key $__rb_prompt_git_refresh_repository_key

        if test -r "$completed_status_file"
            set -g __rb_prompt_git_status_lines (string split \n <"$completed_status_file")
            set -g __rb_prompt_git_status_repository_key $completed_repository_key
            set -g __rb_prompt_git_status_updated_at (command date +%s)
        end

        command rm -f -- "$completed_status_file"
        set -e __rb_prompt_git_status_file
        set -e __rb_prompt_git_refresh_repository_key
        set -e __rb_prompt_git_refreshing
        functions -e __rb_prompt_git_refresh_complete
        commandline -f repaint 2>/dev/null
    end
end

function __rb_prompt_git_render
    set -l status_lines $argv

    set -l branch (command git symbolic-ref --quiet --short HEAD 2>/dev/null)
    if test -z "$branch"
        set branch (command git rev-parse --short HEAD 2>/dev/null)
    end

    set -l dirty
    set -l conflicts
    set -l stashed
    set -l ahead 0
    set -l behind 0
    for line in $status_lines
        if string match --quiet '# branch.ab *' -- $line
            set -l fields (string split ' ' -- $line)
            set ahead (string replace '+' '' -- $fields[3])
            set behind (string replace '-' '' -- $fields[4])
        else if string match --quiet '# stash *' -- $line
            set stashed 1
        else if not string match --quiet '#*' -- $line
            set dirty 1
            string match --quiet 'u *' -- $line; and set conflicts 1
        end
    end

    test -n "$branch"; and printf ' %s%s%s' (set_color blue) $branch (set_color normal)
    test -n "$dirty"; and printf '%s*%s' (set_color brmagenta) (set_color normal)
    test -n "$conflicts"; and printf '%s;%s' (set_color brmagenta) (set_color normal)
    test "$ahead" -gt 0; and printf ' %s⇡%s%s' (set_color cyan) $ahead (set_color normal)
    test "$behind" -gt 0; and printf '%s⇣%s%s' (set_color cyan) $behind (set_color normal)
    test -n "$stashed"; and printf ' %s≡%s' (set_color cyan) (set_color normal)
end

function __rb_prompt_git
    command -q git; or return
    set -l git_dir (command git rev-parse --git-dir 2>/dev/null)
    test -n "$git_dir"; or return

    set -l repository_key "$PWD:$git_dir"
    if not set -q __rb_prompt_git_repository_key; or test "$__rb_prompt_git_repository_key" != "$repository_key"
        set -g __rb_prompt_git_repository_key $repository_key
        set -e __rb_prompt_git_status_lines
        set -e __rb_prompt_git_status_repository_key
        set -e __rb_prompt_git_status_updated_at
    end

    set -l refresh_needed
    if not set -q __rb_prompt_git_status_lines
        set refresh_needed 1
    else if test "$__rb_prompt_git_status_repository_key" != "$repository_key"
        set refresh_needed 1
    else if test (math (command date +%s) - $__rb_prompt_git_status_updated_at) -ge 2
        set refresh_needed 1
    end

    if test -n "$refresh_needed"; and not set -q __rb_prompt_git_refreshing
        __rb_prompt_git_start_refresh $repository_key
    end

    set -q __rb_prompt_git_status_lines; and test "$__rb_prompt_git_status_repository_key" = "$repository_key"; or return
    __rb_prompt_git_render $__rb_prompt_git_status_lines
end

function __rb_prompt_duration
    set -q CMD_DURATION; or return
    test "$CMD_DURATION" -ge 2000; or return

    set -l seconds (math -s0 "$CMD_DURATION / 1000")
    set -l minutes (math -s0 "$seconds / 60")
    set -l remainder (math "$seconds % 60")
    if test "$minutes" -gt 0
        printf '%s%sm %ss%s' (set_color brblack) $minutes $remainder (set_color normal)
    else
        printf '%s%ss%s' (set_color brblack) $seconds (set_color normal)
    end
end

function __rb_prompt_battery
    for battery in /sys/class/power_supply/BAT*
        test -r "$battery/capacity"; and test -r "$battery/status"; or continue
        set -l capacity (string trim <"$battery/capacity")
        set -l battery_status (string trim <"$battery/status")
        if test "$battery_status" = Discharging; and test "$capacity" -le 10
            printf '%s▰%s' (set_color red) (set_color normal)
            return
        end
    end
end

function __rb_prompt_character --argument-names last_status
    if test "$last_status" -eq 0
        printf '%s❯%s ' (set_color --bold green) (set_color normal)
    else
        printf '%s❯%s ' (set_color --bold red) (set_color normal)
    end
end

function __rb_prompt_transient_character
    printf '%s❯%s ' (set_color brblack) (set_color normal)
end

function fish_prompt
    set -l last_status $status

    if contains -- --final-rendering $argv
        __rb_prompt_transient_character
        return
    end

    if set -q SSH_TTY
        printf '%s%s@%s%s ' (set_color green) (whoami) (hostname) (set_color normal)
    end

    __rb_prompt_directory
    __rb_prompt_git
    printf '\n'
    __rb_prompt_battery
    __rb_prompt_character $last_status
end

function fish_right_prompt
    if set -q IN_NIX_SHELL
        printf '%s✱%s ' (set_color yellow) (set_color normal)
    end
    __rb_prompt_duration
end
