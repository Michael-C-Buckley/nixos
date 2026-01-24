{
  config,
  inputs,
  ...
}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.nixos = {
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
    };
  };
}
