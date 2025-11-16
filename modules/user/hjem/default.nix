{
  config,
  inputs,
  ...
}: {
  flake.modules.hjem.default = {
    pkgs,
    lib,
    ...
  }: {
    imports = with config.flake.modules.hjem; [
      direnv
      fish
      git
      shellAliases
      starship
      fastfetch
      nushell
      yazi
      zoxide
      inputs.hjem.nixosModules.hjem
    ];

    programs.fish.enable = true;
    users.users.michael.shell = pkgs.fish;

    hjem = {
      linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
      extraModules = [
        config.flake.modules.hjem.gnupg
        inputs.rum.hjemModules.default
      ];
      users.michael = {
        # Push the existing files in to be merged
        files = import ../_findFiles.nix {inherit lib;};

        environment.sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
          PAGER = "bat";
          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
          NH_FLAKE = "/home/michael/nixos";
          DIFF = "difft";
          GIT_EDITOR = "nvim";
          GPG_TTY = "$(tty)";
          CLICOLOR = "1";
          LSCOLORS = "auto";
          DIFF_COLOR = "auto";
          IP_COLOR = "always";
        };

        # Basic GPG, more advanced settings in gpgAgent
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
