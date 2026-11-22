# ── Environment ──────────────────────────────────────────────────────────────
set -q EDITOR; or set -gx EDITOR vim
set -q VISUAL; or set -gx VISUAL $EDITOR
set -q PAGER; or set -gx PAGER less
set -q LESS; or set -gx LESS '-R -F -X -i'

# XDG base directories. The login environment or a local conf.d file can set them.
test -n "$XDG_CONFIG_HOME"; or set -gx XDG_CONFIG_HOME "$HOME/.config"
test -n "$XDG_DATA_HOME"; or set -gx XDG_DATA_HOME "$HOME/.local/share"
test -n "$XDG_CACHE_HOME"; or set -gx XDG_CACHE_HOME "$HOME/.cache"
test -n "$XDG_STATE_HOME"; or set -gx XDG_STATE_HOME "$HOME/.local/state"
test -n "$XDG_CONFIG_DIRS"; or set -gx --path XDG_CONFIG_DIRS /etc/xdg

if test -z "$XDG_DATA_DIRS"
    set -gx --path XDG_DATA_DIRS /usr/local/share /usr/share
    if command -q brew
        set -l brew_prefix (brew --prefix)
        if test -n "$brew_prefix"; and not contains -- "$brew_prefix/share" $XDG_DATA_DIRS
            set -p XDG_DATA_DIRS "$brew_prefix/share"
        end
    end
end

# ── PATH ─────────────────────────────────────────────────────────────────────
fish_add_path -g /opt/homebrew/sbin /opt/homebrew/bin $HOME/bin $HOME/.local/bin

# ── SSH  ─────────────────────────────────────────────────────────────────────
# Inherit the session agent, including agents forwarded by SSH. Probe legacy
# Linux sockets when the session has no usable socket.
if not test -S "$SSH_AUTH_SOCK"; and test (uname -s) = Linux
    set -l runtime_dir "$XDG_RUNTIME_DIR"
    test -n "$runtime_dir"; or set runtime_dir /run/user/(id -u)
    for agent_sock in "$HOME/.ssh/agent/custom.sock" "$runtime_dir/ssh-agent.sock" "$HOME/.ssh/agent/internal.sock"
        if test -S "$agent_sock"
            set -gx SSH_AUTH_SOCK "$agent_sock"
            break
        end
    end
end

# ── Interactive shell only ───────────────────────────────────────────────────
status is-interactive; or return 0

# Disable the default greeting
set -g fish_greeting

set -g fish_key_bindings fish_hybrid_key_bindings
set -g fish_transient_prompt 1

# Better colors for ls (if available)
set -gx CLICOLOR 1

# Prompt: `prompt` lists them, `prompt NAME` switches for this shell, and
# `prompt --save NAME` makes it the default for new shells
if functions -q prompt
    set -q prompt_style; or set -g prompt_style starship
    prompt $prompt_style; or prompt starship
end

bind -M insert ctrl-backspace backward-kill-word
bind -M insert alt-backspace backward-kill-word

# Local fzf widgets: Ctrl-R searches history, Ctrl-T inserts a file, and Alt-C
# changes directory. These replace the fzf-fish plugin without sourcing it.
if functions -q __rb_fzf_history_widget __rb_fzf_file_widget __rb_fzf_cd_widget
    for mode in default insert
        bind -M $mode \cr __rb_fzf_history_widget
        bind -M $mode \ct __rb_fzf_file_widget
        bind -M $mode alt-c __rb_fzf_cd_widget
    end
end

# ── Shared definitions ───────────────────────────────────────────────────────
# Shared with Zsh (configs/shell/README.md). The Nix wrapper sets
# SHELL_COMMON_DIR; otherwise use the XDG location.
test -n "$SHELL_COMMON_DIR"; or set -g SHELL_COMMON_DIR $XDG_CONFIG_HOME/shell

# __shell_common FILE COMMAND...: run `COMMAND... NAME VALUE` for each entry
# of $SHELL_COMMON_DIR/FILE. A missing file is not an error.
function __shell_common --description 'Apply NAME=VALUE entries of a shared shell file'
    set -l file $SHELL_COMMON_DIR/$argv[1]
    test -r $file; or return 0
    # Skip blank lines, comments, and lines without a name before `=`.
    for line in (string match -r '^\s*[^#\s=][^=]*=.*' <$file)
        set -l pair (string split -m1 = -- $line | string trim)
        $argv[2..-1] $pair
    end
end

# Shared aliases apply only when the command they run is available, so ls stays
# plain ls without eza.
function __shell_alias --description 'Define a shared alias if its command is available'
    type -q -- (string match -r -- '^\S+' $argv[2]); and alias $argv[1] $argv[2]
end

__shell_common abbreviations abbr --add --
__shell_common aliases __shell_alias

# ── Local compatibility aliases ──────────────────────────────────────────────
if not command -q rb && test -x ~/.rootbeer/bin/rb
    alias rb="~/.rootbeer/bin/rb"
end

if not command -q sudo; and command -q doas
    function sudo --wraps doas --description 'Run a command via doas'
        command doas $argv
    end
end

function mkcd
    mkdir -p $argv[1]; and cd $argv[1]
end

if command -q zoxide
    zoxide init fish --cmd z | source
end

if type -q direnv
    direnv hook fish | source
end

function ru --description "Root Fish with my interactive config"
    command sudo env XDG_CONFIG_HOME="$XDG_CONFIG_HOME"
end
