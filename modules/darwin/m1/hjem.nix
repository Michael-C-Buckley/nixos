{
  flake.modules.darwin.m1 = {
    hjem.users.michael = {
      files = {
        ".zshrc".text = ''
          if [[ -o interactive ]]; then
            export GPG_TTY=$(tty)
            export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
          fi
        '';
      };
    };
  };
}
