{
  config,
  inputs,
  ...
}: let
  inherit (config) flake;
in {
  flake.hjemConfig.darwin = {
    pkgs,
    lib,
    ...
  }: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) nvf;
  in {
    imports = [
      inputs.hjem.darwinModules.default
      flake.hjemConfig.default
      flake.hjemConfig.secrets
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
