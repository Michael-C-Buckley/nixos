{
  config,
  inputs,
  ...
}: {
  flake.modules.nixos.hjem-default = {
    pkgs,
    lib,
    ...
  }: {
    imports = with config.flake.modules.nixos;
      [
        hjem-direnv
        hjem-fish
        hjem-git
        hjem-shellAliases
        hjem-starship
        hjem-fastfetch
        hjem-nushell
        hjem-yazi
        hjem-zoxide
      ]
      ++ [
        inputs.hjem.nixosModules.hjem
      ];

    programs.fish.enable = true;
    users.users.michael.shell = pkgs.fish;

    hjem = {
      linker = inputs.hjem.packages.${pkgs.system}.smfh;
      extraModules = [
        config.flake.hjemModules.gnupg
        inputs.hjem-rum.hjemModules.default
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

        # Basic GPG, more advanced settings in hjem-gpg
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
