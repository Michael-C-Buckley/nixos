# Native fish reimplementation of the prompt I have been using on Starship
#
# Kept cheap to redraw:
# - A new prompt runs one `git rev-parse` and one `date`. The branch is read
#   straight from the HEAD file instead of asking git.
# - `git status` runs in the background, and the prompt redraws when it lands
#   if the result changed.
# - Any other redraw (vi mode switches, that async result) reuses the cached
#   values and starts no processes.
# - While the prompt waits for input, the branch and git status refresh every
#   $prompt_refresh_interval seconds (default 5; 0 turns it off). This redraws
#   the prompt in place only when something changed.

# Re-sourcing (e.g. `prompt starship`) starts from a clean cache
set -e __native_prompt_pwd
set -e __native_prompt_git_key
set -g __native_prompt_source (status filename)

function __native_prompt_mark_stale --on-event fish_prompt
    set -g __native_prompt_stale 1
    set -g __native_prompt_git_stale 1
    set -e __native_prompt_busy
end

function __native_prompt_mark_busy --on-event fish_preexec
    set -g __native_prompt_busy 1
end

function __native_prompt_cleanup --on-event fish_exit
    set -q __native_prompt_git_file; and command rm -f -- $__native_prompt_git_file
    __native_prompt_timer_stop
end

# Everything shown except git status, using at most one git process
function __native_prompt_refresh
    set -g __native_prompt_pwd $PWD
    set -g __native_prompt_time (command date '+%H:%M:%S')
    set -g __native_prompt_dir_label (prompt_pwd -d 0)
    set -e __native_prompt_git_dir
    set -e __native_prompt_branch

    command -q git; or return
    set -l info (command git rev-parse --show-toplevel --absolute-git-dir --show-prefix 2>/dev/null)
    or return

    # info is: repo root, git dir, path inside the repo (empty at the root)
    set -l prefix (string trim --right --chars=/ -- "$info[3]")
    if test -n "$prefix"
        set -g __native_prompt_dir_label $prefix
    else
        set -g __native_prompt_dir_label (path basename -- "$info[1]")
    end
    set -g __native_prompt_git_dir $info[2]
    __native_prompt_read_branch
end

# The branch, read from the HEAD file rather than by asking git
function __native_prompt_read_branch
    set -l head
    test -r "$__native_prompt_git_dir/HEAD"; and read -l head <"$__native_prompt_git_dir/HEAD"
    set -l branch (string replace -r '^ref: (refs/heads/)?' '' -- "$head")
    if test "$branch" = "$head"
        # Detached HEAD holds a commit hash
        set branch (string sub -l 7 -- "$head")
    else if test "$branch" = .invalid
        # Reftable repos leave a placeholder in the HEAD file
        set branch (command git symbolic-ref --quiet --short HEAD 2>/dev/null)
    end
    set -g __native_prompt_branch $branch
end

# Start a background git status when one is due. Only one runs at a time; if
# another becomes due meanwhile, it starts when the running one lands.
function __native_prompt_git_kick
    set -q __native_prompt_git_dir; or return
    set -q __native_prompt_git_pid; and return
    set -q __native_prompt_git_stale
    or test "$__native_prompt_git_key" != "$__native_prompt_git_dir"
    or return

    set -e __native_prompt_git_stale
    __native_prompt_git_refresh
end

# Start `git status` in the background; __native_prompt_git_store picks it up
function __native_prompt_git_refresh
    if not set -q __native_prompt_git_file
        set -l tmp /tmp
        set -q TMPDIR[1]; and test -d "$TMPDIR"; and set tmp (string trim --right --chars=/ -- "$TMPDIR")
        set -l file (command mktemp "$tmp/fish-prompt-git.XXXXXX" 2>/dev/null); or return
        set -g __native_prompt_git_file $file
    end

    set -g __native_prompt_git_pending $__native_prompt_git_dir
    # --no-optional-locks stops this from racing your own git commands for
    # index.lock
    command git --no-optional-locks status --porcelain=v2 --branch --show-stash \
        </dev/null >$__native_prompt_git_file 2>/dev/null &
    set -g __native_prompt_git_pid $last_pid

    function __native_prompt_git_done --on-process-exit $last_pid
        __native_prompt_git_store
        set -e __native_prompt_git_pid
        functions -e __native_prompt_git_done
        # Redraw only for a change, so a timer refresh that finds nothing new
        # leaves the screen alone
        if test "$__native_prompt_git_shown" != "$(__native_prompt_git_view)"
            commandline -f repaint 2>/dev/null
        end
        __native_prompt_git_kick
    end
end

# Parse the status output once and keep the rendered text
function __native_prompt_git_store
    # Always record the key, even on failure, so a broken repo can't cause a
    # refresh/redraw loop
    set -g __native_prompt_git_key $__native_prompt_git_pending
    set -g __native_prompt_git_text

    # A successful run always starts with the branch.oid header
    set -l lines (string split \n <$__native_prompt_git_file)
    set -q lines[1]; and string match --quiet '# branch.oid *' -- $lines[1]; or return

    set -l pieces
    if string match --quiet --invert '#*' -- $lines
        # ffafd7 is xterm-256 color 218, matching Starship's git_status
        set -l marker '*'
        string match --quiet 'u *' -- $lines; and set marker '*;'
        set --append pieces (set_color ffafd7)$marker(set_color normal)
    end

    set -l ab (string match --regex --groups-only '^# branch\.ab \+(\d+) -(\d+)$' -- $lines)
    if set -q ab[2]
        test $ab[1] -gt 0; and set --append pieces (set_color cyan)"⇡$ab[1]"(set_color normal)
        test $ab[2] -gt 0; and set --append pieces (set_color cyan)"⇣$ab[2]"(set_color normal)
    end

    if string match --quiet --regex '^# stash [1-9]' -- $lines
        set --append pieces (set_color cyan)'≡'(set_color normal)
    end

    set -q pieces[1]; and set -g __native_prompt_git_text (string join ' ' -- $pieces)' '
end

# The git part of the first line, which tells a finished status whether the
# prompt needs a redraw
function __native_prompt_git_view
    printf '%s%s' (__native_prompt_git_branch) (__native_prompt_git_status)
end

# ── Periodic refresh ─────────────────────────────────────────────────────────
# Fish has no timers, so a small sh loop sends fish SIGWINCH (the terminal
# resize signal) every $prompt_refresh_interval seconds. SIGWINCH is safe for
# this: fish always handles it, and a process that doesn't handle it ignores
# it, whereas SIGUSR1 would kill it. A same-size SIGWINCH doesn't redraw
# anything by itself.

# Re-sourcing restarts the loop with the current interval
function __native_prompt_timer_start
    __native_prompt_timer_stop
    set -l interval 5
    set -q prompt_refresh_interval; and set interval $prompt_refresh_interval
    string match -qr '^[1-9][0-9]*$' -- $interval; or return

    # The loop ends once fish is no longer its parent, or once exec has
    # replaced fish with another program
    command sh -c '
        while sleep "$1"; do
            [ $(ps -o ppid= -p $$) = "$2" ] || exit
            case $(ps -o comm= -p "$2") in *fish*) ;; *) exit ;; esac
            kill -s WINCH "$2" || exit
        done' fish-prompt-timer $interval $fish_pid </dev/null >/dev/null 2>&1 &
    # Exported so that after `exec fish`, the new shell (same PID) stops this
    # loop before starting its own
    set -gx __native_prompt_timer_pid $last_pid
    disown $last_pid
end

function __native_prompt_timer_stop
    set -q __native_prompt_timer_pid; or return
    # Kill it only while it is still our child, in case the PID was reused
    set -l parent (command ps -o ppid= -p $__native_prompt_timer_pid 2>/dev/null | string trim)
    test "$parent" = "$fish_pid"; and command kill $__native_prompt_timer_pid 2>/dev/null
    set -e __native_prompt_timer_pid
end

function __native_prompt_tick --on-signal WINCH
    # `prompt` switched to another prompt: stop until this one is sourced again
    if test "$(functions --details fish_prompt)" != "$__native_prompt_source"
        __native_prompt_timer_stop
        return
    end
    # Only while waiting for input in a repository
    set -q __native_prompt_busy; and return
    set -q __native_prompt_git_dir; or return

    __native_prompt_read_branch
    set -g __native_prompt_git_stale 1
    __native_prompt_git_kick
end

function __native_prompt_dir
    printf '%s%s%s ' (set_color cyan) $__native_prompt_dir_label (set_color normal)
end

function __native_prompt_hostname
    set -q SSH_CONNECTION; or set -q SSH_CLIENT; or return
    printf '%s%s:%s' (set_color 5faf5f) (prompt_hostname) (set_color normal)
end

function __native_prompt_git_branch
    set -q __native_prompt_git_dir; and test -n "$__native_prompt_branch"; or return
    printf '%sgit:(%s%s%s)%s' (set_color blue) (set_color red) $__native_prompt_branch (set_color blue) (set_color normal)
end

function __native_prompt_git_status
    # Only show a result that belongs to the repo we're in now
    set -q __native_prompt_git_dir; or return
    test "$__native_prompt_git_key" = "$__native_prompt_git_dir"; or return
    printf '%s' $__native_prompt_git_text
end

function __native_prompt_cmd_duration
    set -l duration $argv[1]
    test -n "$duration"; or return
    test "$duration" -ge 2000; or return

    set -l seconds (math "floor($duration / 1000)")
    set -l minutes (math "floor($seconds / 60)")
    set -l remainder (math "$seconds % 60")

    if test "$minutes" -gt 0
        printf '%s%sm %ss%s ' (set_color yellow) $minutes $remainder (set_color normal)
    else
        printf '%s%ss%s ' (set_color yellow) $seconds (set_color normal)
    end
end

function __native_prompt_nix_shell
    set -q IN_NIX_SHELL; or return

    switch "$IN_NIX_SHELL"
        case pure
            printf '%s✱ %s' (set_color green) (set_color normal)
        case impure
            printf '%s✱ %s' (set_color yellow) (set_color normal)
        case '*'
            printf '%s✱ %s' (set_color red) (set_color normal)
    end
end

function __native_prompt_time
    printf '%s%s%s' (set_color brblack) $__native_prompt_time (set_color normal)
end

function __native_prompt_jobs
    set -l pids (jobs -p)
    # Don't count this prompt's own background git status
    if set -q __native_prompt_git_pid; and set -q pids[1]
        set pids (string match --invert -- $__native_prompt_git_pid $pids)
    end

    set -l job_count (count $pids)
    test "$job_count" -gt 0; or return

    if test "$job_count" -eq 1
        printf '%s✦%s ' (set_color --bold brblue) (set_color normal)
    else
        printf '%s✦%s%s ' (set_color --bold brblue) $job_count (set_color normal)
    end
end

function __native_prompt_python
    set -l env_name
    if set -q VIRTUAL_ENV
        set env_name (path basename -- "$VIRTUAL_ENV")
    else if set -q CONDA_DEFAULT_ENV
        set env_name $CONDA_DEFAULT_ENV
    end

    test -n "$env_name"; or return
    printf '%s%s%s ' (set_color brblack) $env_name (set_color normal)
end

function __native_prompt_battery
    for battery in /sys/class/power_supply/BAT*
        test -r "$battery/capacity"; or continue
        test -r "$battery/status"; or continue

        read -l capacity <"$battery/capacity"
        read -l state <"$battery/status"

        if test "$state" = Discharging; and test "$capacity" -le 10
            printf '%s%s%%%s ' (set_color red) $capacity (set_color normal)
            return
        end
    end
end

function __native_prompt_character
    set -l last_status $argv[1]
    set -l color green

    if test "$last_status" -ne 0
        set color red
    end

    if test "$fish_bind_mode" = default
        printf '%s❮%s ' (set_color --bold brblue) (set_color normal)
    else
        printf '%s❯%s ' (set_color --bold $color) (set_color normal)
    end
end

function __native_prompt_first_line
    set -l cmd_duration $argv[1]
    printf '%s%s%s%s%s' \
        (__native_prompt_hostname) \
        (__native_prompt_dir) \
        (__native_prompt_git_branch) \
        (__native_prompt_git_status) \
        (__native_prompt_cmd_duration $cmd_duration)
end

function __native_prompt_right
    printf '%s%s' (__native_prompt_nix_shell) (__native_prompt_time)
end

function __native_prompt_second_line
    set -l last_status $argv[1]
    printf '%s%s%s%s' \
        (__native_prompt_battery) \
        (__native_prompt_jobs) \
        (__native_prompt_python) \
        (__native_prompt_character $last_status)
end

function fish_prompt
    set -l last_status $status

    if contains -- --final-rendering $argv
        printf '%s' (__native_prompt_character $last_status)
        return
    end

    # Refresh on a new prompt or after a cd from a key binding; plain redraws
    # use the cache
    if set -q __native_prompt_stale; or test "$__native_prompt_pwd" != "$PWD"
        set -e __native_prompt_stale
        __native_prompt_refresh
    end

    __native_prompt_git_kick

    set -l cmd_duration 0
    set -q CMD_DURATION; and set cmd_duration $CMD_DURATION

    set -l left (__native_prompt_first_line $cmd_duration)
    set -g __native_prompt_git_shown (__native_prompt_git_view)
    set -l right (__native_prompt_right)

    set -l columns 80
    set -q COLUMNS; and set columns $COLUMNS

    set -l left_width (string length --visible -- "$left")
    set -l right_width (string length --visible -- "$right")
    set -l fill_width (math "$columns - $left_width - $right_width")
    test "$fill_width" -gt 1; or set fill_width 1

    printf '%s%s%s\n' $left (string repeat --count $fill_width ' ') $right
    printf '%s' (__native_prompt_second_line $last_status)
end

__native_prompt_timer_start
