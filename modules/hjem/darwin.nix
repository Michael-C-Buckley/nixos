{
  config,
  inputs,
  ...
}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.darwin = {
    pkgs,
    lib,
    ...
  }: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) nvf;
  in {
    imports = [
      inputs.hjem.darwinModules.default
      flake.hjemConfigs.default
      flake.hjemConfigs.secrets
    ];

    hjem.users.michael = {
      directory = "/Users/michael";

      packages = [
        pkgs.ghostty-bin
        # iproute2 on mac and with an override for color
        (pkgs.writeShellApplication {
          name = "ip";
          text = ''
            exec ${pkgs.iproute2mac}/bin/ip -c "$@"
          '';
        })
        # Adds my NVF under the nvf command
        (pkgs.writeShellApplication {
          name = "nvf";
          text = ''
            exec ${lib.getExe nvf} "$@"
          '';
        })
      ];
    };
  };
}
