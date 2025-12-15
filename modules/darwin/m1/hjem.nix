{
  flake.modules.darwin.m1 = {
    hjem.users.michael = {
      git.signingKey = "6F749AA097DC10EA46FE0ECD22CDD3676227046F!";
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
