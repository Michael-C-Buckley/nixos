# ── Settings ─────────────────────────────────────────────────────────────────
# Merged into whatever config.nu already set. The Nix wrapper appends its
# extraConfig to the end of this file.

$env.config = ($env.config | merge deep {
    show_banner: false
    buffer_editor: "nvim"
    edit_mode: emacs

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    rm: {
        always_trash: true
    }

    table: {
        mode: heavy
        index_mode: always
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
        }
    }

    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 50
        }
    }

    cursor_shape: {
        emacs: line
        vi_insert: line
        vi_normal: block
    }

    shell_integration: {
        osc2: true              # set terminal title
        osc7: true              # notify terminal of cwd
        osc9_9: false
        osc133: true            # shell prompt markers (for terminal apps)
        osc633: true
        reset_application_mode: true
    }

    render_right_prompt_on_last_line: false
})

# Replace rather than duplicate if this file is loaded twice
$env.config.keybindings = (
    $env.config.keybindings
    | where name != backspace_kill_word
    | append {
        # Kitty sends this for Ctrl-Backspace, and Ctrl-H is agreeable too
        name: backspace_kill_word
        modifier: control
        keycode: char_h
        mode: [emacs, vi_insert, vi_normal]
        event: { edit: backspaceword }
    }
)
