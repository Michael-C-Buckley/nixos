{config, ...}: let
  inherit (config.flake) modules packageLists;
  inherit (config.flake.hjemConfigs) nixos root;
in {
  flake.modules.nixos.cloudPreset = {
    pkgs,
    functions,
    ...
  }: {
    imports = with modules.nixos; [
      linuxPreset
      network
      zfs
      shawn
      pam-ssh
      packages

      # Users
      michael-attic
      michael-fish

      # Hjem
      nixos
      root
    ];

    environment.systemPackages =
      functions.packageLists.combinePkgLists (with packageLists; [
        cli
        network
      ])
      ++ [
        config.flake.packages.${pkgs.stdenv.hostPlatform.system}.vim
      ];
  };
}
