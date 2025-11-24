# Home-Manager for my WSL Alpine Instance
{
  flake.modules.homeManager.alpine = {
    config,
    pkgs,
    ...
  }: {
    home = {
      packages = with pkgs; [
        iproute2 # better than busybox's limited ip tool
        lazygit
      ];

      file = {
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

              # Set default shell to customized fish from Nix
              fish
          fi

        '';
      };
    };
  };
}
