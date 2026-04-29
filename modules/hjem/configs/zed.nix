{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom) wrappers;
  flakePackages = config.flake.packages;
in {
  flake.custom.hjemConfigs.zed = {
    pkgs,
    config,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    hjem.users.${config.custom.hjem.username} = {
      packages = lib.optionals (lib.hasSuffix "darwin" system) [flakePackages.${system}.zedPkgs];
      xdg.config.files."zed/settings.json" = {
        clobber = false;
        source = wrappers.mkZedConfig {inherit pkgs;};
        type = "copy";
        permissions = "0644";
      };
    };
  };
}
