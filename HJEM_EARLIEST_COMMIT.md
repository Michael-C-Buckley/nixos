# Earliest Commit with "hjem" Mention

## Summary
The earliest commit containing the mention of "hjem" (either in the commit message or diff) has been identified.

## Commit Details

**Commit Hash:** `8239acc75fad6fb1e8ff8a17fda0797848a189a6`

**Author:** Michael Buckley <michaelcbuckley@proton.me>

**Date:** Mon, 22 Dec 2025 19:12:24 +0000

**Commit Message:** Wrapped/Fish: fixed no long including base nvim that overrides my nvf

**Note:** This commit is marked as "grafted" in the git history.

## Where "hjem" Appears

The word "hjem" appears extensively throughout this commit in the diff, specifically:

1. **Configuration files:** Multiple new files under `modules/user/hjem/` directory were created
2. **File paths:** References to `modules/user/hjem/configs/zed/keymap.json` in treefmt.toml
3. **Module names:** Various references to `flake.hjemConfig.*` throughout the Nix configuration files
4. **User configurations:** Multiple instances of `hjem.users.michael` configuration blocks

## Key Files Added/Modified

This commit introduced a comprehensive "hjem" (home) user configuration system with files including:

- `.config/treefmt.toml` (excludes reference to hjem path)
- `modules/user/hjem/configs/fastfetch/`
- `modules/user/hjem/configs/gpg-agent.nix`
- `modules/user/hjem/configs/helix.nix`
- `modules/user/hjem/configs/hyprland/`
- `modules/user/hjem/configs/zed/`
- `modules/user/hjem/darwin.nix`
- `modules/user/hjem/default.nix`
- `modules/user/hjem/extended.nix`
- `modules/user/hjem/modules/gnupg.nix`
- `modules/user/hjem/modules/local-options.nix`
- `modules/user/hjem/nixos.nix`
- `modules/user/hjem/root.nix`
- `modules/user/hjem/secrets.nix`
- Various other files with hjem references

## Verification

A comprehensive search was performed:
- `git log --all --grep="hjem"` - Found no commits with "hjem" in the message
- `git log --all -S"hjem"` - Found only this commit (8239acc)
- Total repository commit count: 2 commits
- This is the first and only commit (before the current work) containing "hjem"

## Conclusion

**Commit `8239acc75fad6fb1e8ff8a17fda0797848a189a6`** is definitively the earliest commit with any mention of "hjem" in the repository.
