{inputs, ...}: {
  flake.modules.nixos.hjem-wsl = {
    config,
    lib,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      hjem-default
      hjem-cursor
    ];

    hjem.users.michael = {
      packages = [
        (lib.hiPrio inputs.self.packages.${config.nixpkgs.system}.nvf)
      ];
    };
  };
}
