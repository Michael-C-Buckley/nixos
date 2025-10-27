{config, ...}: {
  flake.modules.nixos.hjem-wsl = {
    pkgs,
    lib,
    ...
  }: {
    imports = with config.flake.modules.nixos; [
      hjem-default
      hjem-cursor
      hjem-helix
    ];

    hjem.users.michael = {
      packages = [
        (lib.hiPrio pkgs.nvf)
      ];
    };
  };
}
