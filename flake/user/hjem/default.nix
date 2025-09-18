# Split into per-host basis
{
  pkgs,
  lib,
  customPkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ../options.nix
    ./configs
  ];

  programs.fish.enable = mkDefault true;
  users.users.michael.shell = pkgs.fish;

  hjem = {
    extraModules = [
      ./modules/gpg.nix
    ];
    users.michael = {
      enable = true;
      user = "michael";
      directory = "/home/michael";
      packages = import ../packageSets/common.nix {inherit customPkgs pkgs;};

      # Push the existing files in to be merged
      files = import ../findFiles.nix {inherit lib;};

      environment.sessionVariables = {
        EDITOR = "nvim";
        BROWSER = "schizofox";
        VISUAL = "nvim";
        PAGER = "bat";
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        DIFF = "difft";
        GIT_EDITOR = "nvim";
        NIXOS_OZONE_WL = 1;
        GTK_USE_PORTAL = 1;
      };

      gnupg = {
        enable = true;
        config.extraLines = ''
          auto-key-locate local
          auto-key-retrieve
        '';
        agent = {
          allowLoopbackPinentry = true;
          enableSSHsupport = true;
        };
        scdaemon.disable-ccid = true;
      };
    };
  };
}
