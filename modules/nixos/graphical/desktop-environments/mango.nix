{
  config,
  inputs,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.mango = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    imports = [inputs.mango.nixosModules.mango];

    programs.mango = {
      enable = true;
      package = inputs.mango.packages.${system}.mango;
    };

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) grim slurp wl-clipboard;
      inherit (flake.packages.${system}) noctalia;
    };
  };
}
