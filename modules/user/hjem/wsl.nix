{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.hjem-wsl = {
    pkgs,
    lib,
    ...
  }: {
    imports = with flake.modules.nixos; [
      hjem-default
      hjem-cursor
    ];

    hjem.users.michael = {
      packages = [
        (lib.hiPrio flake.packages.${pkgs.system}.nvf)
      ];
    };
  };
}
