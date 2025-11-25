{
  flake.modules.darwin.m1 = {
    files = {
      # Hjem-Rum will not work with Darwin so it must be
      # declared independently and set fish as the
      # terminal shell
      # Random self-note:
      # Themes I had liked: Everblush, Everforest, Gruvbox, Tomorrow Night Bright, Peppermint
      ".config/ghostty/config".text = ''
        command=fish
        theme="Wombat"
        background="#000000"
        font-size=11
        font-family=Cascadia Code NF

        background-opacity=1
        cursor-opacity=0.6
        cursor-color=#44A3A3

        window-theme=system
      '';

      # My zshrc uses fish for interactive shells, that way
      # the login shell is not changed, for compatibility
      ".zshrc".text = ''
        if [[ -o interactive ]]; then
          export GPG_TTY=$(tty)
          export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
          exec fish
        fi
      '';
    };
  };
}
