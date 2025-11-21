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
      git
      shellAliases
      fastfetch
      nushell
      yazi
      zoxide
    ];

    programs.fish = {
      enable = true;
      package = config.flake.packages.${pkgs.stdenv.hostPlatform.system}.fish;
    };

    hjem = {
      linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
      extraModules = [
        config.flake.hjemModules.gnupg
        inputs.hjem-rum.hjemModules.default
      ];
      users.michael = {
        # Push the existing files in to be merged
        files = import ../_findFiles.nix {inherit lib;};

        packages = [
          # add this to stop the shell error from my wrapped fish since something touched it after creation
          config.flake.packages.${pkgs.stdenv.hostPlatform.system}.starship
          pkgs.bat
          pkgs.eza
        ];

        environment.sessionVariables = {
          EDITOR = "nvf";
          VISUAL = "nvf";
          PAGER = "bat";
          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
          DIFF = "difft";
          GIT_EDITOR = "nvf";
          GPG_TTY = "$(tty)";
          CLICOLOR = "1";
          DIFF_COLOR = "auto";
        };

        # Basic GPG, more advanced settings in hjem-gpgAgent
        gnupg = {
          enable = true;
          pinentryPackage = lib.mkDefault pkgs.pinentry-curses;
          config.extraLines = ''
            auto-key-locate local
            auto-key-retrieve
          '';
        };
      };
    };
  };
}
