{
  config,
  inputs,
  ...
}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.darwin = {pkgs, ...}: {
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
      ];
    };
  };
}
