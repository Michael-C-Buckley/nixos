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
      flake.hjemConfig.secrets
    ];

    hjem.users.michael = {
      environment.sessionVariables = {
        IP_COLOR = "always";
        NH_FLAKE = "/home/michael/nixos";
      };
      packages = [
        # Makes `nvf` work as a command, disambiguating from `nvim`
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
