{
  flake.modules.homeManager.alpine = {config, ...}: {
    home.file = {
      ".profile".text = ''
        export ENV="$HOME/.ashrc"

        # Standalone nix
        . "$HOME/.nix-profile/etc/profile.d/nix.sh" 2>/dev/null || true

          eval $(wsl2-ssh-agent)
      '';

      ".ashrc".text = ''
        # Some aliases if I'm not using my nix setup
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'

        # Set Less to use color when paging
        # This is overridden by Bat when using my shell, but this will
        # at least be available everywhere else when not

        export LESS='-R'
        export LESS_TERMCAP_mb=$'\e[1;31m'
        export LESS_TERMCAP_md=$'\e[1;36m'
        export LESS_TERMCAP_me=$'\e[0m'
        export LESS_TERMCAP_so=$'\e[01;44;33m'
        export LESS_TERMCAP_se=$'\e[0m'
        export LESS_TERMCAP_us=$'\e[1;32m'
        export LESS_TERMCAP_ue=$'\e[0m'
        export MANPAGER="less"

        if [ -z "$DISABLE_NIX_PROFILE" ]; then
            # Activate Nix profile
            . "${config.home.profileDirectory}"

            # Set default shell to customized fish from Nix
            fish
        fi
      '';
    };
  };
}
