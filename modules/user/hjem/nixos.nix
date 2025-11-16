{
  config,
  inputs,
  ...
}: let
  inherit (config) flake;
in {
  flake.hjemConfig.nixos = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.hjem.nixosModules.default
      flake.hjemConfig.default
    ];

    hjem.users.michael = {
      packages = [
        (pkgs.writeShellApplication {
          name = "nvf";
          text = ''
            exec ${lib.getExe config.programs.nvf.finalPackage} "$@"
          '';
        })
      ];
    };
  };
}
