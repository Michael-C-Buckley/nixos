{
  config,
  inputs,
  ...
}: {
  flake.hjemConfig.default = {
    pkgs,
    lib,
    ...
  }: {
    imports = with config.flake.hjemConfig; [
      direnv
      fish
      git
      shellAliases
      starship
      fastfetch
      nushell
      yazi
      zoxide
    ];

    programs.fish.enable = true;

    hjem = {
      linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
      extraModules = [
        config.flake.hjemModules.gnupg
        inputs.hjem-rum.hjemModules.default
      ];
      users.michael = {
        # Push the existing files in to be merged
        files = import ../_findFiles.nix {inherit lib;};

        packages = with pkgs; [
          bat
          eza
        ];

        environment.sessionVariables = {
          EDITOR = "nvf";
          VISUAL = "nvf";
          PAGER = "bat";
          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
          NH_FLAKE = "/home/michael/nixos";
          DIFF = "difft";
          GIT_EDITOR = "nvf";
          GPG_TTY = "$(tty)";
          CLICOLOR = "1";
          LSCOLORS = "auto";
          DIFF_COLOR = "auto";
          IP_COLOR = "always";
        };

        # Basic GPG, more advanced settings in hjem-gpgAgent
        gnupg = {
          enable = true;
          pinentryPackage = pkgs.pinentry-curses;
          config.extraLines = ''
            auto-key-locate local
            auto-key-retrieve
          '';
        };
      };
    };
  };
}
