{
  config,
  inputs,
  ...
}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.nixos = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.hjem.nixosModules.default
      flake.hjemConfigs.default
    ];

    hjem.users.michael = {
      environment.sessionVariables = {
        IP_COLOR = "always";
        NH_FLAKE = "/home/michael/nixos";
        NIXPKGS_ALLOW_FREE = 1;
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
