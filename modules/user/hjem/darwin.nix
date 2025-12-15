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
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) ghostty nvf;
  in {
    imports = [
      inputs.hjem.darwinModules.default
      flake.hjemConfig.default
      flake.hjemConfig.secrets
    ];

    hjem.users.michael = {
      directory = "/Users/michael";
      gnupg.pinentryPackage = pkgs.pinentry_mac; # Underscore unlike all other pinentry packages

      packages = [
        ghostty
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
            exec ${lib.getExe nvf} "$@"
          '';
        })
      ];
    };
  };
}
