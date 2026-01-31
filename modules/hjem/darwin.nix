{
  config,
  inputs,
  ...
}: {
  flake.hjemConfigs.darwin = {pkgs, ...}: {
    imports = [
      inputs.hjem.darwinModules.default
      config.flake.hjemConfigs.default
      config.flake.hjemConfigs.secrets
    ];

    hjem.users.michael = {
      directory = "/Users/michael";

      packages = [
        pkgs.ghostty-bin
        # iproute2 on mac and with an override for color
        (pkgs.writeShellApplication {
          name = "ip";
          text = ''exec ${pkgs.iproute2mac}/bin/ip -c "$@"'';
        })
      ];
    };
  };
}
