{
  config,
  inputs,
  ...
}: let
  inherit (config) flake;
in {
  flake.hjemConfig.default = {
    pkgs,
    lib,
    ...
  }: {
    imports = with flake.hjemConfig; [
      direnv
      git
      shellAliases
      fastfetch
      nushell
      yazi
      zoxide
    ];

    programs.fish.enable = true;

    hjem = {
      linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
      extraModules = [
        flake.hjemModules.gnupg
        inputs.hjem-rum.hjemModules.default
      ];
      users.michael = {
        # Push the existing files in to be merged
        files = import ../_findFiles.nix {inherit lib;};

        packages = [
          # add this to stop the shell error from my wrapped fish since something touched it after creation
          flake.packages.${pkgs.stdenv.hostPlatform.system}.starship
          pkgs.bat
          pkgs.eza
        ];

        # I reuse these elsewhere, so don't warn me
        rum.environment.hideWarning = true;

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
