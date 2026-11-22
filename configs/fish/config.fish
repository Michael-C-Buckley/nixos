# ── Environment ──────────────────────────────────────────────────────────────
set -gx EDITOR vim
set -gx VISUAL vim
set -gx PAGER less
set -gx LESS '-R -F -X -i'
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx NH_FLAKE $HOME/.config/nixos

# XDG base directories
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_STATE_HOME $HOME/.local/state
set -q XDG_CONFIG_DIRS[1]; or set -gx --path XDG_CONFIG_DIRS /etc/xdg
set -q XDG_DATA_DIRS[1]; or set -gx --path XDG_DATA_DIRS /usr/local/share /usr/share

if command -q brew
    set -l brew_data_dir (brew --prefix)/share
    contains -- $brew_data_dir $XDG_DATA_DIRS; or set -gx --path XDG_DATA_DIRS $brew_data_dir $XDG_DATA_DIRS
end

# ── PATH ─────────────────────────────────────────────────────────────────────
fish_add_path -g /opt/homebrew/sbin /opt/homebrew/bin $HOME/bin $HOME/.local/bin

# ── SSH  ─────────────────────────────────────────────────────────────────────
# macOS ships OpenSSH without libfido2 support. Nix-darwin owns this fixed
# socket with a nixpkgs OpenSSH agent; do not fall back to Apple's agent.
set fido_agent "$HOME/.ssh/agent/nix-fido.sock"
set custom_agent "$HOME/.ssh/agent/custom.sock"
set internal_agent "$HOME/.ssh/agent/internal.sock"
set standard_agent /run/user/(id -u)/ssh-agent.sock

if test (uname) = Darwin
    set -gx SSH_AUTH_SOCK $fido_agent
else
    if not set -q SSH_AUTH_SOCK; or not test -S "$SSH_AUTH_SOCK"
        for agent_sock in $custom_agent $standard_agent $internal_agent
            if test -S $agent_sock
                set -gx SSH_AUTH_SOCK $agent_sock
                break
            end
        end
    end
end

# ── Interactive shell only ───────────────────────────────────────────────────
status is-interactive; or return

# Disable the default greeting
set -g fish_greeting

set -g fish_key_bindings fish_hybrid_key_bindings
set -g fish_transient_prompt 1

# Better colors for ls (if available)
set -gx CLICOLOR 1

# Prompt: `prompt` lists them, `prompt NAME` switches for this shell, and
# `prompt --save NAME` makes it the default for new shells
set -q prompt_style; or set -g prompt_style starship
prompt $prompt_style; or prompt starship

bind -M insert ctrl-backspace backward-kill-word
bind -M insert alt-backspace backward-kill-word

# Local fzf widgets: Ctrl-R searches history, Ctrl-T inserts a file, and Alt-C
# changes directory. These replace the fzf-fish plugin without sourcing it.
for mode in default insert
    bind -M $mode \cr __rb_fzf_history_widget
    bind -M $mode \ct __rb_fzf_file_widget
    bind -M $mode alt-c __rb_fzf_cd_widget
end

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
    set -l user_config_home $HOME/.config
    command sudo env XDG_CONFIG_HOME=$user_config_home
end
