# Split into per-host basis
{
  config,
  pkgs,
  lib,
  customPkgs,
  ...
}: let
  inherit
    (config.hjem.users.michael)
    fileList
    packageList
    ;

  inherit (lib) mkDefault;

  myPkgs = import ../packageSets/common.nix {inherit customPkgs pkgs;};
in {
  imports = [
    ../options.nix
    ./configs
  ];

  programs.fish.enable = mkDefault true;

  users.users.michael = {
    packages = myPkgs ++ packageList;
    shell = pkgs.fish;
  };

  hjem = {
    extraModules = [
      ./modules/hjemOptions.nix
      ./modules/gpg.nix
    ];
    users.michael = {
      enable = true;
      user = "michael";
      directory = "/home/michael";

      # Push the existing files in to be merged
      files = (import ../findFiles.nix {inherit lib;}) // fileList;

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
