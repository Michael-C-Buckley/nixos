{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) packages;
in {
  flake.hjemConfig.darwin = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.hjem.darwinModules.default
      config.flake.hjemConfig.default
    ];

    hjem.users.michael = {
      directory = "/Users/michael";
      gnupg.pinentryPackage = pkgs.pinentry_mac; # Underscore unlike all other pinentry

      packages = [
        # iproute2 on mac and with an override for color
        (pkgs.writeShellApplication {
          name = "iproute2mac";
          text = ''
            exec ${pkgs.iproute2mac}/bin/ip -c "$@"
          '';
        })
        # Adds my NVF under the nvf command
        (pkgs.writeShellApplication {
          name = "nvf";
          text = ''
            exec ${lib.getExe packages.${pkgs.stdenv.hostPlatform.system}.nvf} "$@"
          '';
        })
      ];
    };
  };
}
