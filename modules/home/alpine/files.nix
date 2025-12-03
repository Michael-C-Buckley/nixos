{
  flake.modules.homeManager.alpine = {config, ...}: {
    home.file = {
      ".profile".text = ''
        export ENV="$HOME/.ashrc"
      '';

      ".ashrc".text = ''
        # Some aliases if I'm not using my nix setup
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'

        if [ -z "$DISABLE_NIX_PROFILE" ]; then
            # Activate Nix profile
            . "${config.home.profileDirectory}"

            # Set SSH_AUTH_SOCK for GPG agent
            export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

            # Set default shell to customized fish from Nix
            fish
        fi
      '';

      ".gnupg/scdaemon.conf".text = ''
        disable-ccid
      '';
    };
  };
}
