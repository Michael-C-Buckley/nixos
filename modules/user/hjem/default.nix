{inputs, ...}: {
  flake.modules.nixos.hjem-default = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (lib) mkDefault;
    inherit (config.nixpkgs) system;
    inherit (inputs.self.packages.${system}) nvf-minimal ns;
  in {
    imports = with inputs.self.modules.nixos;
      [
        hjem-direnv
        hjem-fish
        hjem-git
        hjem-helix
        hjem-shellAliases
        hjem-starship
        hjem-fastfetch
      ]
      ++ [
        inputs.hjem.nixosModules.hjem
      ];

    programs.fish.enable = mkDefault true;
    users.users.michael.shell = pkgs.fish;

    hjem = {
      linker = pkgs.smfh;
      extraModules = [
        inputs.self.hjemModules.gnupg
        inputs.hjem-rum.hjemModules.default
      ];
      users.michael = {
        # Push the existing files in to be merged
        files = import ../_findFiles.nix {inherit lib;};

        packages = [ns nvf-minimal];

        environment.sessionVariables = {
          EDITOR = "nvim";
          BROWSER = "helium";
          VISUAL = "nvim";
          PAGER = "bat";
          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
          DIFF = "difft";
          GIT_EDITOR = "nvim";
          NIXOS_OZONE_WL = 1;
          GTK_USE_PORTAL = 1;
          NH_FLAKE = "/home/michael/nixos";
          GPG_TTY = "$(tty)";
          CLICOLOR = 1;
          LSCOLORS = "auto";
          DIFF_COLOR = "auto";
          IP_COLOR = "always";
        };

        gnupg = {
          enable = true;
          pinentryPackage = pkgs.pinentry-curses;
          config.extraLines = ''
            digest-algo SHA256
            auto-key-locate local
            auto-key-retrieve
          '';
          agent = {
            allowLoopbackPinentry = true;
            enableSSHsupport = true;
            extraLines = ''
              card-timeout 1
            '';
          };
          scdaemon = {
            #extraLines = ''pcsc-driver'';
            disable-ccid = true;
          };
        };
      };
    };
  };
}
