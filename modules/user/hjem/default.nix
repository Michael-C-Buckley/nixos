{config, ...}: let
  inherit (config) flake;
in {
  flake.hjemConfig.default = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = with flake.hjemConfig; [
      fastfetch
    ];

    hjem = {
      linker = pkgs.smfh;
      extraModules = [
        flake.hjemModules.gnupg
        flake.hjemModules.localOptions
      ];
      users.michael = {
        # Push the existing files in to be merged
        files = import ../_findFiles.nix {inherit lib;};

        packages = [
          pkgs.bat
          pkgs.eza
          pkgs.nushell

          # add this to stop the shell error from my wrapped fish since something touched it after creation
          flake.packages.${pkgs.stdenv.hostPlatform.system}.starship

          # Add the appropriate wrapped git for the system
          (flake.wrappers.mkGit {
            inherit pkgs;
            inherit (config.hjem.users.michael.git) signingKey;
          })
        ];

        environment.sessionVariables = {
          EDITOR = "nvf";
          VISUAL = "nvf";
          PAGER = "bat";
          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
          DIFF = "difft";
          GIT_EDITOR = "nvf";
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
