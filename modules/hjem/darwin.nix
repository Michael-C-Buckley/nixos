{
  config,
  inputs,
  ...
}: {
  flake.custom.hjemConfigs.darwin = {pkgs, ...}: {
    imports = [
      inputs.hjem.darwinModules.default
      config.flake.custom.hjemConfigs.default
      config.flake.custom.hjemConfigs.zed
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
